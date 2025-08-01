# noteformyself Document Class - Usage Guide

## Overview
The `noteformyself` document class supports three different section levels through the `sectionlevel` option:

1. `sectionlevel=section` (default) - Uses article class with sections as top level
2. `sectionlevel=chapter` - Uses article class but treats sections like chapters
3. `sectionlevel=book` - Uses book class with proper chapter/section/subsection hierarchy

## Usage Examples

### Book Mode (New!)
```latex
\documentclass[sectionlevel=book]{noteformyself}

\title{My Mathematical Notes}
\author{Your Name}
\date{\today}
\authorinfo{University/Affiliation}
\coversentence{Advanced topics in mathematics}
\coverimage{cover.png}

\begin{document}

\maketitle

\chapter{First Chapter}
This is the first chapter of your book.

\section{First Section}
This is a section within the first chapter.

\subsection{A Subsection}
This is a subsection.

\begin{definition}
This definition will be numbered as Definition 1.1 (chapter.definition).
\end{definition}

\begin{theorem}
This theorem will be numbered as Theorem 1.2.
\end{theorem}

\chapter{Second Chapter}
This is the second chapter.

\begin{definition}
This will be Definition 2.1 since it's in the second chapter.
\end{definition}

\end{document}
```

### Chapter Mode (Existing)
```latex
\documentclass[sectionlevel=chapter]{noteformyself}
% Uses article class but sections behave like chapters
```

### Section Mode (Default)
```latex
\documentclass{noteformyself}
% or explicitly: \documentclass[sectionlevel=section]{noteformyself}
% Uses article class with normal section hierarchy
```

## Key Differences

| Feature | Section Mode | Chapter Mode | Book Mode |
|---------|-------------|--------------|-----------|
| Base Class | article | article | book |
| Top Level | \section | \section (styled as chapter) | \chapter |
| Cover Page | Simple | Full page | Full page |
| Theorem Numbering | By definition order | By section | By chapter |
| Page Layout | Single-sided | Single-sided | Double-sided (book style) |

## When to Use Each Mode

- **Section Mode**: For shorter notes, homework assignments, or single-topic documents
- **Chapter Mode**: For longer documents that need chapter-like organization but don't need the complexity of book class
- **Book Mode**: For comprehensive textbooks, thesis documents, or multi-chapter works that benefit from book-class features like proper chapter breaks, different page numbering, etc.
