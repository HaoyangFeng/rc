call pathogen#infect()
call togglebg#map("<F5>")
nnoremap <c-c> :wqa!<ENTER>

::filetype plugin on

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
syntax enable
set background=light
colorscheme solarized

let fortran_fold=1
let fortran_fold_conditionals=1
"let fortran_fold_multilinecomments=1

"set foldmethod=syntax

set relativenumber
set cursorline
set ruler
set showmode
set showcmd
set gdefault
set ttyfast
set statusline=2
set incsearch
set hlsearch
set ignorecase
set smartcase
set tags=/home/haoyang.feng/.vimtags

set clipboard=unnamedplus

let mapleader=","
nnoremap / /\v
nnoremap <LEADER>t :TlistToggle<ENTER>
nnoremap <silent><F12> :TlistAddFilesRecursive .<ENTER>:TlistToggle<ENTER>
nnoremap <silent><F11> :TlistAddFilesRecursive 
nnoremap <silent><SPACE> za
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-n> :n<ENTER>
nnoremap <c-p> :N<ENTER>
nnoremap <silent><F8> :se nosi<ENTER> :se nornu<ENTER>
nnoremap <silent><F9> :se rnu<ENTER> :se si<ENTER>
nnoremap * *zz
nnoremap # #zz
nnoremap n nzz
nnoremap N Nzz
nnoremap ` '
nnoremap ' `
nnoremap <c-]> <c-]>zz
nnoremap ]c ]czz
nnoremap [c [czz
nnoremap <LEADER>c 0R//<ESC>j
"cnoremap <ENTER> <ENTER>zt


"svn blame
" Show in a new window the Subversion blame annotation for the current file.
" Problem: when there are local mods this doesn't align with the source file.
" To do: When invoked on a revnum in a Blame window, re-blame same file up to
" previous rev.
:function s:svnBlame()
  let line = line(".")
  setlocal nowrap
  aboveleft 18vnew
  setlocal nomodified readonly buftype=nofile nowrap winwidth=1
  NoSpaceHi
  " blame, ignoring white space changes
  %!svn blame -x-w "#"
  " find the highest revision number and highlight it
  "%!sort -n
  "normal G*u
  " return to original line
  exec "normal " . line . "G"
  setlocal scrollbind
  wincmd p
  setlocal scrollbind
  syncbind
:endfunction
:map <LEADER>b :call <SID>svnBlame()<CR>
:command Blame call s:svnBlame() 

:function PrepareGoogleDoc()
  silent! s/<[^>]*>/\r&\r/
  silent! g/^$/d
  silent! %s/>\n</></
  exec "normal /^[^<]\<CR>"
  silent! syn match markup "<.*>"
  silent! hi link markup Comment
  silent! syn match content "^[^\<].*$"
  silent! hi link content Keyword
:endfunction
:map <LEADER>g :call <SID>prepareGoogleDoc()<CR>
:command Google call s:prepareGoogleDoc()

:let g:easytags_auto_update = 0
:autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
:let b:easytags_auto_highlight = 0
":let g:TypesFileIncludeLocals = 1
