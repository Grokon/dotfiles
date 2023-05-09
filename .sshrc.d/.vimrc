  
"           ██
"          ░░
"  ██    ██ ██ ██████████  ██████  █████
" ░██   ░██░██░░██░░██░░██░░██░░█ ██░░░██
" ░░██ ░██ ░██ ░██ ░██ ░██ ░██ ░ ░██  ░░
"  ░░████  ░██ ░██ ░██ ░██ ░██   ░██   ██
"   ░░██   ░██ ███ ░██ ░██░███   ░░█████
"    ░░    ░░ ░░░  ░░  ░░ ░░░     ░░░░░
"
"  ▓▓▓▓▓▓▓▓▓▓
" ░▓ author ▓ grokon
" ░▓ code   ▓ http://
" ░▓ mirror ▓ http://git.io/.gy
" ░▓ File:  ▓ vimrc
" ░▓▓▓▓▓▓▓▓▓▓
" ░░░░░░░░░░
"

" use vim settings, rather than vi settings
" must be first, because it changes other options as a side effect
autocmd!
set nocompatible                                        " be iMproved (Must be first line)

" Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if has('win32') || has('win64')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
    else
        set shell=/bin/bash
    endif
" }


" ┏━┓┏━┓┏━┓╻┏━╸
" ┣━┫┣━┫┗━┓┃┃  
" ┗━┛╹ ╹┗━┛╹┗━╸
" ----------------------------------------------------- {{{

    " lang en_US.UTF-8
    set nu
    set title                                           " display filename (not Thank you for using Vim.)
    set ruler                                           " display ruler (60,7 13%)
    set showcmd                                         " show inputting key

    set incsearch                                       " do incremental searching
    set hlsearch                                        " hilight searches by default
    set ignorecase                                      " Case insensitive search - поиск без учёта регистра символов
    set smartcase                                       " Case sensitive when uc present

    set clipboard=unnamed                               " sharing clipboard
    if has('termguicolors')
        set termguicolors
    endif
    colorscheme desert
    set ambiwidth=double

    " indents and tabs
    set shiftwidth=2                                    " размер отступов (нажатие на << или >>)
    set expandtab                                       " tabs are spaces, not tabs - преобразовать табуляцию в пробелы
    set tabstop=2                                       " an indentation every four columns - ширина табуляции
    set softtabstop=2                                   " let backspace delete indent - ширина 'мягкого' таба
    
    set tw=0 " text width
    if version >=800 || has("nvim")
        set breakindent
    endif
    set formatoptions=q
    autocmd FileType * setlocal formatoptions-=ro

    set nobackup " do not create *~ files
    if version >= 703
        set noundofile " do not create *.un~ files
    endif
    set backupskip=/tmp/*,/private/tmp/*
    set cmdheight=1
    set virtualedit=block

    augroup HighlightTrailingSpaces
        autocmd!
        autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=green ctermbg=green
        autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
    augroup END

    " complement { after Enter
    inoremap {<Enter> {}<Left><CR><ESC><S-o>

    let g:python_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'

    let g:loaded_ruby_provider = 1
    let g:loaded_node_provider = 1

" }}}

" ┏━┓╺┳┓╺┳┓┏━┓┏┓╻┏━┓
" ┣━┫ ┃┃ ┃┃┃ ┃┃┗┫┗━┓
" ╹ ╹╺┻┛╺┻┛┗━┛╹ ╹┗━┛
" ----------------------------------------------------- {{{

" External Configurations {

let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_toml = s:dein_dir . '/rc/dein.toml'
let s:dein_toml_lazy = s:dein_dir . '/rc/dein_lazy.toml'

if !isdirectory(s:dein_repo) && strlen($SSH_CLIENT) == 0
    echo "Cloning dein.vim..."
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo))
    if v:shell_error != 0
        echo "Error while cloning dein.vim."
    end
endif

if isdirectory(s:dein_repo)
    if has('vim_starting')
        execute "set runtimepath+=" . s:dein_repo
    endif
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)
        if filereadable(s:dein_toml)
            call dein#load_toml(s:dein_toml)
        endif
        if filereadable(s:dein_toml_lazy)
            call dein#load_toml(s:dein_toml_lazy, {'lazy': 1})
        endif
        call dein#end()
        call dein#save_state()
    endif
    if has('vim_starting') && dein#check_install()
        call dein#install()
    endif
endif

" https://github.com/Shougo/dein.vim
filetype plugin indent on
syntax enable

set laststatus=2
set t_Co=256

" quickly edit .vimrc
command! Ev edit $MYVIMRC
command! Eg edit $MYGVIMRC
command! Sv source $MYVIMRC
command! Sg source $MYGVIMRC

" quickly remove trailing whitespaces
fun! TrimTrailingWhitespaces()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimTrailingWhitespaces call TrimTrailingWhitespaces()

" automatically apply .vimrc changes
augroup MyAutoCmd
    autocmd!
augroup END

if has('gui_running')
    autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC | if has('gui_running') | source $MYGVIMRC
    autocmd MyAutoCmd BufWritePost $MYGVIMRC if has ('gui_running') | source $MYGVIMRC
else
    autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
endif