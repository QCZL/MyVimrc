" 基本功能 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"显示行号
set number
"在状态栏显示正在输入的命令
set showcmd
"设置历史记录条数
set history=1000
"设置取消备份 禁止临时文件的生成
set nobackup
set noswapfile
"设置匹配模式,类似当输入一个左括号时会匹配相应的那个右括号
set showmatch
"设置C/C++方式自动对齐
set autoindent
set cindent
"开启语法高亮功能
syntax enable
syntax on
"设置搜索时忽略大小写
set ignorecase
"实时显示搜索结果
set incsearch
"配置backspace的工作方式
set backspace=indent,eol,start
"设置在vim中可以使用鼠标
set mouse=a
"设置tab宽度
set tabstop=4
"设置自动对齐空格数
set shiftwidth=4
"设置退格键时可以删除4个空格
set smarttab
set softtabstop=4
"将tab键自动转换为空格
set expandtab
"设置编码方式
set encoding=utf-8
"自动判断编码时 依次尝试以下编码
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"检测文件类型
filetype on
"针对不同的文件采取不同的缩进方式
filetype indent on
"启动智能补全
filetype plugin indent on
"直接使用y p进行系统级复制粘贴
set clipboard=unnamedplus
" 不要图形按钮  
set go=
" 用浅色高亮当前行           			
autocmd InsertEnter * se cul  
" 输入的命令显示出来，看的清楚些 
set showcmd     
" 不要闪烁(不明白)  
set novisualbell    
" 不允许折叠 
set nofoldenable 
" 去掉输入错误的提示声音
set noeb
" 设置在编辑过程中右下角显示光标的行列信息
" set ruler
" 设置 laststatus = 0 ，不显式状态行
" 设置 laststatus = 1 ，仅当窗口多于一个时，显示状态行
" 设置 laststatus = 2 ，总是显式状态行
set laststatus=2
" set statusline=%F%m%r%h%w%=\ [ft=%Y]\ %{\"[fenc=\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"]\"}\ [ff=%{&ff}]\ [asc=%03.3b]\ [hex=%02.2B]\ [pos=%05l,%05v][%p%%]\ [len=%L]

" 高亮显示光标所在行和列
set cursorcolumn
set cursorline

" 打开文件重新回到上次退出的位置
if has("autocmd") 
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 
endif

" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif

" 新建.c,.h,.sh,.java,.cpp文件，自动插入文件头 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile *.cpp,*.h,*c,*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#!/bin/sh")
        call append(line("."), "") 
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python3")
        call append(line("."),"# coding=utf-8")
        call append(line(".")+1, "") 
    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
        call append(line(".")+1, "")
    elseif &filetype == 'mkd'
        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "	> File Name         : ".expand("%")) 
        call append(line(".")+1, "	> Author            : chengcheng") 
        call append(line(".")+2, "	> Mail              : qczl_smiling@outlook.com") 
        call append(line(".")+3, "	> Created Time      : ".strftime("%c"))
        call append(line(".")+4, "	> Description       : ")
        call append(line(".")+5, " ************************************************************************/") 
        call append(line(".")+6, "")
    endif
    if expand("%:e") == 'cpp'
        call append(line(".")+7, "#include <iostream>")
        call append(line(".")+8, "using namespace std;")
        call append(line(".")+9, "")
        call append(line(".")+10, "")
    endif
    if &filetype == 'c'
        call append(line(".")+7, "#include <stdio.h>")
        call append(line(".")+8, "#include <stdlib.h>")
        call append(line(".")+9, "")
        call append(line(".")+10, "")
    endif
    if expand("%:e") == 'h'
        call append(line(".")+7, "#ifndef _".toupper(expand("%:r"))."_H")
        call append(line(".")+8, "#define _".toupper(expand("%:r"))."_H")
        call append(line(".")+9, "#endif")
        call append(line(".")+10, "")
    endif
    if &filetype == 'java'
        call append(line(".")+7,"public class ".expand("%:r"))
        call append(line(".")+8,"")
        call append(line(".")+9, "")
    endif
endfunc 
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G

" 快捷键管理  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 去空行 
nnoremap <F2> :g/^\s*$/d<CR>

"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    elseif &filetype == 'py'
        exec "!python %"
        exec "!python %<"
    endif
endfunc

" bundles 插件管理
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vim/.vimrc.bundles"))
    source ~/.vim/.vimrc.bundles
endif
