% 自定义文档类：noteformyself
% by Tianle Yang
% !TeX program = xelatex
% !TEX encoding = UTF-8 Unicode
\ProvidesClass{noteformyself}[2025/05/03 自定义笔记文档类]
\LoadClass{article} % 基础文档类（article）

%--------------------------------------------------------------------------
% 页面布局配置
%--------------------------------------------------------------------------
\RequirePackage[a4paper,
  top=1in,
  bottom=0.5in,
  left=.5in,
  right=.5in,
  includefoot,    % 包含页脚区域
  footskip=0pt    % 首页页脚基线距离
]{geometry}

%--------------------------------------------------------------------------
% 警告过滤配置（抑制常见编译警告）
%--------------------------------------------------------------------------
\RequirePackage{silence}
\WarningFilter{fancyhdr}{\headheight is too small}  % 抑制页眉高度警告
\WarningFilter{fancyhdr}{\footheight is too small}  % 抑制页脚高度警告
\WarningFilter{fancyhdr}{\footskip is too small}    % 抑制页脚间距警告
\WarningFilter{hyperref}{Ignoring empty anchor}     % 抑制空锚点警告

%--------------------------------------------------------------------------
% 核心包加载（按功能分组，保持加载顺序）
%--------------------------------------------------------------------------
% 基础功能包
\RequirePackage{graphicx}       % 图形插入支持
\RequirePackage{adjustbox}      % 高级图片调整（支持max width/height）
\RequirePackage{framed}         % 边框环境
\RequirePackage{amsmath,amsthm,amssymb,amsfonts} % 数学公式基础包
\RequirePackage{mathtools}      % 数学公式增强包
\RequirePackage{mathrsfs}       % 数学特殊字体
\RequirePackage[dvipsnames]{xcolor} % 颜色支持
\RequirePackage[most]{tcolorbox} % 彩色盒子环境
\RequirePackage{tikz}           % 矢量绘图
\RequirePackage[all]{xy}        % 交换图绘制
\RequirePackage{bbm}            % 黑板粗体数字
\RequirePackage{enumitem}       % Required for custom labels

% 中文支持
\RequirePackage[scheme=plain]{ctex} % 中文基础方案
\RequirePackage{fontspec}      % 字体配置

% 引用系统
\RequirePackage[backend=biber,style=numeric]{biblatex} % 参考文献管理
\addbibresource{ref.bib}

% 交互功能
\RequirePackage{hyperref}       % 超链接支持
\RequirePackage[nameinlink]{cleveref} % 智能引用（自动添加前缀）

% 页面装饰
\RequirePackage{fancyhdr}       % 页眉页脚定制
\RequirePackage[bottom,multiple]{footmisc} % 脚注增强

%--------------------------------------------------------------------------
% 文档元数据定义（支持封面页调用）
%--------------------------------------------------------------------------
\makeatletter
% 作者信息处理（支持封面页和脚注）
\let\oldauthor\author
\renewcommand{\author}[1]{%
  \oldauthor{#1}%
  \gdef\@author{#1}%
}
\gdef\@author{} % 初始化作者变量

% 标题信息处理
\let\oldtitle\title
\renewcommand{\title}[1]{%
  \oldtitle{#1}%
  \gdef\@title{#1}%
}
\gdef\@title{} % 初始化标题变量

% 日期信息处理
\let\olddate\date
\renewcommand{\date}[1]{%
  \olddate{#1}%
  \gdef\@date{#1}%
}
\gdef\@date{} % 初始化日期变量

% 自定义封面元素
\gdef\@authorinfo{}     % 作者附加信息
\newcommand{\authorinfo}[1]{\gdef\@authorinfo{#1}}
\gdef\@coversentence{}  % 封面标语
\newcommand{\coversentence}[1]{\gdef\@coversentence{#1}}
\gdef\@coverimage{}     % 封面图片路径
\newcommand{\coverimage}[1]{\gdef\@coverimage{#1}}
\gdef\@coverlinecolor{orange!80!yellow} % 封面装饰线颜色
\newcommand{\coverlinecolor}[1]{\gdef\@coverlinecolor{#1}}
\gdef\@covertitlefont{Brush Script MT}  % 封面标题字体
\newcommand{\covertitlefont}[1]{\gdef\@covertitlefont{#1}}
\gdef\@covertextcolor{purple!70!blue}   % 封面文字颜色
\newcommand{\covertextcolor}[1]{\gdef\@covertextcolor{#1}}
\makeatother

%--------------------------------------------------------------------------
% 章节标题格式配置
%--------------------------------------------------------------------------
\RequirePackage{titlesec}
\renewcommand{\thesubsection}{\arabic{subsection}}  % 章节编号格式
\titleformat{\section}[block]{\normalfont\LARGE\bfseries}{}{0em}{}
\titleformat{\subsection}[block]{\normalfont\Large\bfseries}{\thesubsection}{1em}{}

%--------------------------------------------------------------------------
% 页眉页脚样式配置
%--------------------------------------------------------------------------
\makeatletter
\pagestyle{fancy}
% 页眉样式
\fancyhead[R]{%
  \tikz[baseline=(char.base)]{
    \node[shape=rectangle,fill=gray,text=white,inner sep=2pt] (char) {\thepage};
  }%
}
\fancyhead[L]{\nouppercase{\@title}}
\renewcommand{\headrule}{%
  \vbox to 0pt{%
    \color{gray}%
    \hrule width \headwidth height \headrulewidth%
    \vss%
  }%
}
\renewcommand{\headrulewidth}{4pt}

% 页脚样式（留空）
\renewcommand{\footrule}{%
  \vbox to -10pt{%
    \color{gray}%
    \hrule width \headwidth height \headrulewidth%
    \vss%
  }%
}
\fancyfoot{}
\makeatother

%--------------------------------------------------------------------------
% 封面页重定义
%--------------------------------------------------------------------------
\makeatletter
\renewcommand{\maketitle}{%
  \newgeometry{%
    top=.825in,
    bottom=0.7in,
    left=.5in,
    right=.5in,
    includefoot,
    footskip=0pt
  }
  \begin{titlepage}
    \thispagestyle{fancy}
    
    % 封面装饰线配置
    \gdef\biglineheight{10pt}
    \gdef\smalllineheight{4pt}
    \gdef\spaceheight{11pt}
    \renewcommand{\headrule}{%
      \vbox to 0pt{%
        \color{\@coverlinecolor}%
        \hrule width \headwidth height \biglineheight%
        \vspace{\spaceheight}%
        \hrule width \headwidth height \smalllineheight%
        \vss%
      }%
    }
    \renewcommand{\headrulewidth}{2mm}
    \fancyhead{}
    
    % 页脚装饰线配置
    \renewcommand{\footrule}{%
      \vbox to 0pt{%
        \color{\@coverlinecolor}%
        \hrule width \headwidth height \smalllineheight%
        \vspace{\spaceheight}%
        \hrule width \headwidth height \biglineheight%
        \vss%
      }%
    }
    \fancyfoot{}
    
    % 标题排版
    \vspace*{1mm}
    \begin{flushleft}
      \begin{minipage}{0.8\textwidth}
        \fontspec{\@covertitlefont}
        \fontsize{40pt}{48pt}\selectfont
        \textcolor{\@covertextcolor}{\@title}
      \end{minipage}
    \end{flushleft}
    
    % 封面图片
    \vfill
    \begin{figure}[ht]
      \centering
      \adjustimage{max width=0.6\textwidth, max height=0.5\textheight, keepaspectratio}{\@coverimage}
    \end{figure}
    
    % 封面标语
    \vspace{0.8cm}
    \begin{flushright}
      \begin{minipage}{0.5\textwidth}
        \begin{flushright}
          \large \textcolor{\@covertextcolor}{\@coversentence}
        \end{flushright}
      \end{minipage}
    \end{flushright}
    
    \vspace{0.8cm}
  \end{titlepage}
  \restoregeometry
  \clearpage
  
  % 文档信息脚注
  \renewcommand{\thefootnote}{}
  \footnotetext{\textbf{Date}: \@date,\ \textbf{Author}: \@author,\ \@authorinfo}
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}
}
\makeatother

%--------------------------------------------------------------------------
% 超链接全局配置
%--------------------------------------------------------------------------
\hypersetup{
    colorlinks = true,
    linkcolor = blue,
    filecolor = blue,
    urlcolor = blue,
    citecolor=cyan,
}

%--------------------------------------------------------------------------
% 定理环境可视化配置
%--------------------------------------------------------------------------
% 定义定理样式模板
\newtheoremstyle{mystyle}{}{}{}{}{\bfseries}{.}{ }{}
\theoremstyle{mystyle}

% 定义具体定理环境（共享计数器）
\newtheorem{definition}{Definition}
\newtheorem{proposition}[definition]{Proposition}
\newtheorem{def-prop}[definition]{Def-Prop}
\newtheorem{theorem}[definition]{Theorem}
\newtheorem{lemma}[definition]{Lemma}
\newtheorem{corollary}[definition]{Corollary}
\newtheorem{remark}[definition]{Remark}
\newtheorem{example}[definition]{Example}
\theoremstyle{definition}
\newtheorem{exercise}[definition]{Exercise}

% 定理环境可视化配置（统一使用tcolorbox实现）
% 定义环境配置（颜色方案：蓝色系）
\tcolorboxenvironment{definition}{
  boxrule=0pt,         % 边框粗细（0pt表示无外边框）
  boxsep=0pt,          % 内容与边框间距
  colback={blue!10},   % 背景颜色（蓝色10%透明度）
  left=8pt,            % 左内边距
  right=8pt,           % 右内边距
  enhanced jigsaw,     % 启用高级边框绘制（解决某些兼容问题）
  borderline west={2pt}{0pt}{blue}, % 左侧装饰线（2pt粗细，蓝色）
  sharp corners,        % 直角边框（默认圆角）
  before skip=10pt,    % 上方间距
  after skip=10pt,     % 下方间距
  breakable            % 允许跨页断行
}

% 定义-命题环境配置（颜色方案：蓝色-紫色）
\tcolorboxenvironment{def-prop}{
  boxrule=0pt,         % 边框粗细（0pt表示无外边框）
  boxsep=0pt,          % 内容与边框间距
  colback={blue!10!purple!10},   % 背景颜色（蓝色10%透明度）
  left=8pt,            % 左内边距
  right=8pt,           % 右内边距
  enhanced jigsaw,     % 启用高级边框绘制（解决某些兼容问题）
  borderline west={2pt}{0pt}{blue!50!purple}, % 左侧装饰线（2pt粗细，蓝色）
  sharp corners,        % 直角边框（默认圆角）
  before skip=10pt,    % 上方间距
  after skip=10pt,     % 下方间距
  breakable            % 允许跨页断行
}
 
% 命题环境配置（颜色方案：紫色系）
\tcolorboxenvironment{proposition}{
  boxrule=0pt,
  boxsep=0pt,
  colback={purple!10}, % 背景色改为紫色10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{purple}, % 左侧装饰线改为紫色
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 定理环境配置（颜色方案：红色系）
\tcolorboxenvironment{theorem}{
  boxrule=0pt,
  boxsep=0pt,
  colback={red!10},    % 背景色改为红色10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{red},    % 左侧装饰线改为红色
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 引理环境配置（颜色方案：品红系）
\tcolorboxenvironment{lemma}{
  boxrule=0pt,
  boxsep=0pt,
  colback={magenta!10},% 背景色改为品红10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{magenta},% 左侧装饰线改为品红
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 推论环境配置（颜色方案：橙色系）
\tcolorboxenvironment{corollary}{
  boxrule=0pt,
  boxsep=0pt,
  colback={Orange!10}, % 背景色改为橙色10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{Orange}, % 左侧装饰线改为橙色
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 证明环境配置（特殊样式：无背景色，左侧线为青灰色）
\tcolorboxenvironment{proof}{
  boxrule=0pt,
  boxsep=0pt,
  blanker,             % 清除所有默认样式
  borderline west={2pt}{0pt}{CadetBlue!80!white}, % 青灰色左侧线
  left=8pt,
  right=8pt,
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 示例环境配置（特殊样式：无背景色，左侧线为绿色）
\tcolorboxenvironment{example}{
  boxrule=0pt,
  boxsep=0pt,
  % blanker,
  % borderline west={2pt}{0pt}{Green}, % 绿色左侧线
  % left=8pt,
  % right=8pt,
  % before skip=10pt,
  % after skip=10pt,
  % breakable
  colback={Green!10}, % 背景色改为橙色10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{Green}, % 左侧装饰线改为橙色
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 注记环境配置（特殊样式：无背景色，左侧线为黑色）
\tcolorboxenvironment{remark}{
  boxrule=0pt,
  boxsep=0pt,
  blanker,
  borderline west={2pt}{0pt}{Black},  % 黑色左侧线
  left=8pt,
  right=8pt,
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}
 
% 练习环境配置（颜色方案：紫罗兰系）
\tcolorboxenvironment{exercise}{
  boxrule=0pt,
  boxsep=0pt,
  % colback={violet!10}, % 背景色改为紫罗兰10%透明度
  left=8pt,
  right=8pt,
  enhanced jigsaw,
  borderline west={2pt}{0pt}{violet}, % 左侧装饰线改为紫罗兰色
  sharp corners,
  before skip=10pt,
  after skip=10pt,
  breakable
}

%--------------------------------------------------------------------------
% 自定义实用命令
%--------------------------------------------------------------------------
\newcommand{\Yang}[1]{\textcolor{red}{Yang: #1}} % 批注命令
\input{notation.tex}            % 加载符号定义文件