# Note_on_Algebraic_Geometry

A note on algebraic geometry, starting from Hartshorne.

This project allows you to compile every section independently.
The files `noteformyself.cls`, `notation.tex`, and `ref.bib` are referenced through symbolic links.
This maybe available only on windows system.
If you clone the repository directly, the symbolic links will not be restored.
If you need to compile it locally after cloning, please run the following command with administrator privileges:

```bash
git clone --config core.symlinks=true https://github.com/MonkeyUnderMountain/Note_on_Algebraic_Geometry.git
```

Alternatively, you can run the following command with administrator privileges in advance:

```bash
git config --global core.symlinks true
```

本项目每一节可以独立编译, 其中 `noteformyself.cls`, `notation.tex`, `ref.bib`三个文件通过符号链接引用.
这一功能可能仅在windows系统上可用.
直接克隆无法复原符号链接, 若需要克隆后本地编译, 请以管理员权限运行以下命令:

```bash
git clone --config core.symlinks=true https://github.com/MonkeyUnderMountain/Note_on_Algebraic_Geometry.git
```

或者提前以管理员权限运行以下命令:

```bash
git config --global core.symlinks true
```
