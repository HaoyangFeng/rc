"Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'

Plugin 'pangloss/vim-javascript'
let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
let g:javascript_conceal_static     = "•"
let g:javascript_conceal_super      = "Ω"

Plugin 'jelera/vim-javascript-syntax'
Plugin 'sjl/gundo.vim'

Plugin 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](node_modules|lib|bower_components)$',
	\ 'file': '\v\.(exe|so|dll|swp)$',
	\ 'link': 'some_bad_symbolic_links',
	\ }

Plugin 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'Valloric/YouCompleteMe'

Plugin 'marijnh/tern_for_vim'
let g:tern_map_keys=1
let g:tern_map_prefix = '<leader>'
let g:tern_show_argument_hints='on_move'
let tern#is_show_argument_hints_enabled = 1

Plugin 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=2

Plugin 'scrooloose/syntastic'
let g:syntastic_check_on_open=1

call vundle#end()
filetype plugin indent on

"Theme
colorscheme solarized
set background=light
syntax enable

"Settings
set smartindent
set tabstop=2
set shiftwidth=2
set noexpandtab
set foldenable
set foldmethod=syntax
set foldlevelstart=1
set foldnestmax=10
set number
set relativenumber
set cursorline
set ruler
set showmode
set showcmd
set showmatch
set wildmenu
set lazyredraw
set gdefault
set ttyfast
set statusline=2
set incsearch
set hlsearch
set ignorecase
set smartcase
"set clipboard=unnamedplus
if has('conceal')
	set conceallevel=1
	set concealcursor=nvic
endif

"Mappings
let mapleader=","
nnoremap <c-c> :qa!<enter>
nnoremap <nul> :wq!<enter>
nnoremap / /\v
nnoremap <leader><space> :nohlsearch<enter>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <silent><space> za
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-n> :n<enter>
nnoremap <c-N> :N<enter>
nnoremap <silent><F8> :se nosi<enter> :se nornu<enter>
nnoremap <silent><F9> :se rnu<enter> :se si<enter>
nnoremap * *zz
nnoremap # #zz
nnoremap n nzz
nnoremap N Nzz
"nnoremap j jzz
"nnoremap k kzz
nnoremap ` '
nnoremap ' `
nnoremap <c-]> <c-]>zz
nnoremap ]c ]czz
nnoremap [c [czz
nnoremap <leader>c 0R//<esc>j
nnoremap gV `[v`]
"map <leader> <Plug>(easymotion-prefix)
map ; <Plug>(easymotion-s)
map <leader>m <Plug>(easymotion-bd-w)
map  / <Plug>(easymotion-sn)
"cnoremap <enter> <enter>zt


:autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,.git/*

augroup configgroup
	autocmd!
	autocmd BufEnter *.msh setlocal foldmethod=marker
	autocmd BufEnter *.msh setlocal foldlevel=0
augroup END




"Fortran
let fortran_fold=1
let fortran_fold_conditionals=1
"let fortran_fold_multilinecomments=1

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
:map <leader>g :call <SID>prepareGoogleDoc()<CR>
:command Google call s:prepareGoogleDoc()

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
:map <leader>b :call <SID>svnBlame()<CR>
:command Blame call s:svnBlame() 
