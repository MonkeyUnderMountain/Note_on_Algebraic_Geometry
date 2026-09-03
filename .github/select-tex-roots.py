#!/usr/bin/env python3
"""Select the standalone TeX documents affected by repository changes."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import TypedDict, cast


class Status(TypedDict):
    published: int
    finished: int


class Section(TypedDict):
    id: str
    title: str
    order: int
    tex: str
    url: str
    status: Status


class Chapter(TypedDict):
    id: str
    title: str
    order: int
    tex: str
    url: str
    status: Status
    sections: list[Section]


class Book(TypedDict):
    id: str
    title: str
    tex: str
    url: str
    status: Status
    chapters: list[Chapter]


class Manifest(TypedDict):
    schemaVersion: int
    build: dict[str, str]
    book: Book


def is_within(path: PurePosixPath, directory: PurePosixPath) -> bool:
    """Return whether path is directory itself or is below it."""
    return path == directory or directory in path.parents


def changed_paths(base: str, head: str) -> list[PurePosixPath]:
    """Read changed paths from Git without misparsing spaces or Unicode."""
    result = subprocess.run(
        ["git", "diff", "--name-only", "-z", f"{base}..{head}", "--"],
        check=True,
        stdout=subprocess.PIPE,
    )
    names = result.stdout.decode("utf-8", errors="surrogateescape").split("\0")
    return [PurePosixPath(name) for name in names if name]


def all_roots(book: Book) -> list[PurePosixPath]:
    """Return all compilation roots in manifest order."""
    roots = [PurePosixPath(book["tex"])]
    for chapter in book["chapters"]:
        roots.append(PurePosixPath(chapter["tex"]))
        roots.extend(PurePosixPath(section["tex"]) for section in chapter["sections"])
    return roots


def select_roots(
    book: Book,
    changes: list[PurePosixPath],
    pdf_cache: Path,
    force_full: bool,
) -> list[PurePosixPath]:
    """Select changed documents and any parent documents containing them."""
    ordered_roots = all_roots(book)
    if force_full:
        return ordered_roots

    book_root = PurePosixPath(book["tex"])
    selected: set[PurePosixPath] = set()
    rebuild_all = False

    for changed in changes:
        # The accessories submodule is intentionally excluded from automatic
        # change detection. Use the workflow's full_build option when a new
        # template, font, notation file, or bibliography must be propagated.
        if changed == PurePosixPath("accessories") or is_within(
            changed, PurePosixPath("accessories")
        ):
            continue

        if changed == PurePosixPath(".gitmodules"):
            rebuild_all = True
            break

        if changed == book_root:
            selected.add(book_root)

        matched_chapter = False
        for chapter in book["chapters"]:
            chapter_root = PurePosixPath(chapter["tex"])
            chapter_directory = chapter_root.parent
            if not is_within(changed, chapter_directory):
                continue

            matched_chapter = True
            selected.update((book_root, chapter_root))
            for section in chapter["sections"]:
                section_root = PurePosixPath(section["tex"])
                if is_within(changed, section_root.parent):
                    selected.add(section_root)
                    break
            break

        if matched_chapter:
            continue

        # A shared source or asset outside the managed chapter tree can affect
        # every standalone document. Root-level assets affect only the book.
        if changed.suffix.lower() in {".bib", ".cls", ".otf", ".sty", ".ttf"}:
            rebuild_all = True
            break
        if len(changed.parts) == 1 and changed.suffix.lower() in {
            ".bbl",
            ".eps",
            ".jpg",
            ".jpeg",
            ".pdf",
            ".png",
            ".tex",
        }:
            selected.add(book_root)

    if rebuild_all:
        return ordered_roots

    # A missing previous PDF must be rebuilt even when its source did not
    # change. This also repairs an incomplete prior deployment automatically.
    for root in ordered_roots:
        cached_pdf = pdf_cache.joinpath(*root.with_suffix(".pdf").parts)
        if not cached_pdf.is_file():
            selected.add(root)

    return [root for root in ordered_roots if root in selected]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, default=Path("notes.json"))
    parser.add_argument("--pdf-cache", type=Path, default=Path("_pdf-cache"))
    parser.add_argument("--base")
    parser.add_argument("--head", default="HEAD")
    parser.add_argument("--full", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    raw_manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    manifest = cast(Manifest, raw_manifest)

    if args.full:
        changes: list[PurePosixPath] = []
    elif args.base:
        changes = changed_paths(args.base, args.head)
    else:
        print("Either --base or --full is required.", file=sys.stderr)
        return 2

    roots = select_roots(manifest["book"], changes, args.pdf_cache, args.full)
    for root in roots:
        print(root.as_posix())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
