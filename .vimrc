
" General "{{{
set nocompatible  " disable vi compatibility.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set autoread  
set timeoutlen=250
set clipboard+=unnamed  " Yanks go on clipboard instead.
set pastetoggle=<F10> "  toggle between paste and normal: for 'safer' pasting from keyboard
set tags=./tags;$HOME " walk directory tree upto $HOME looking for tags
" Modeline
set modeline
set modelines=5 " default numbers of lines to read for modeline instructions
" Backup
set writebackup
set backup
set directory=/tmp// " prepend(^=) $HOME/.tmp/ to default path; use full path as backup filename(//)
set backupdir=~/.vimbackup
" Buffers
set hidden " The current buffer can be put to the background without writing to disk
" Match and search
set hlsearch    " highlight search
set ignorecase  " Do case in sensitive matching with
set smartcase   " be sensitive when there's a capital letter
set incsearch
set showmatch
" "}}}

" Formatting "{{{
set fo+=o  " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set fo+=mB " for multibyte character 
"set fo-=r  " Do not automatically insert a comment leader after an enter
set fo-=t  " Do no auto-wrap text using textwidth (does not apply to comments)

set nowrap
set textwidth=0		" Don't wrap lines by default
set wildmode=longest,list " At command line, complete longest common string, then list alternatives.

set backspace=indent,eol,start	" more powerful backspacing

set tabstop=2    " Set the default tabstop
set softtabstop=2
set shiftwidth=2 " Set the default shift width for indents
set expandtab   " Make tabs into spaces (set by tabstop)
set smarttab " Smarter tab levels

set autoindent

syntax on               " enable syntax
" "}}}

" Visual "{{{
set nonumber  " Line numbers off
set showmatch  " Show matching brackets.
set matchtime=5  " Bracket blinking.
set novisualbell  " No blinking
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.
set vb t_vb= " disable any beeps or flashes on error
set ruler  " Show ruler
set showcmd " Display an incomplete command in the lower right corner of the Vim window
set shortmess=atI " Shortens messages

set nolist " Display unprintable characters f12 - switches
"set listchars=tab:·\ ,eol:¶,trail:·,extends:»,precedes:« " Unprintable chars mapping

set foldenable " Turn on folding
set foldmethod=marker " Fold on the marker
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds 

set mouse-=a   " Disable mouse
set mousehide  " Hide mouse after chars typed

set splitbelow
set splitright

set title

set wildmenu

"colorscheme gmarik
colorscheme desert

hi Pmenu     ctermbg=0            guibg=#666666
hi PmenuSel  ctermbg=1 ctermfg=7* guibg=#ffdddd guifg=#333333
hi PmenuSbar ctermbg=4            guibg=#333333
"highlight Pmenu ctermbg=8 guibg=#606060
"highlight PmenuSel ctermbg=12 guibg=Orange
"highlight PmenuSbar ctermbg=0 guibg=White
" "}}}

" Command and Auto commands " {{{
" Sudo write
comm! W exec 'w !sudo tee % > /dev/null' | e!

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif " restore position in file
" " }}}

" StatusLine " {{{
function! GetStatusEx()
  let str = ''
  let str .= '[' . &filetype . ']'
  let str .= '[' . &fileformat . ']'
  if has('multi_byte') && &fileencoding != ''
    let str .= '[' . &fileencoding . ']'
  endif
  return str
endfunction

set statusline=%<%f\ %m%r%h%w%{GetStatusEx()}%=%l,%c%V%8P
" " }}}

" Japanese " {{{
set fileencodings=ucs-bom,utf-8,default,cp932,sjis,euc-jp-ms,euc-jp,iso-2022-jp-3
let skk_jisyo = "~/.skk-jisyo"
let skk_large_jisyo = "~/.skk.d/SKK-JISYO"
" "}}}

" Windows " {{{
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif
" " }}}


" Plugins " {{{
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Vim
Bundle "YankRing.vim"
Bundle "http://github.com/thinca/vim-poslist.git"

" Programming
Bundle "rails.vim"
Bundle "http://github.com/thinca/vim-quickrun.git"
Bundle "http://github.com/gmarik/snipmate.vim.git"
Bundle "http://github.com/rstacruz/sparkup.git", {'rtp': 'vim/'}
Bundle "http://github.com/kchmck/vim-coffee-script"
Bundle "stickykey"

" Syntax highlight
Bundle "jQuery"
Bundle "cucumber.zip"
Bundle "Markdown"
Bundle "https://github.com/timcharper/textile.vim.git"

" Git integration
Bundle "git.zip"
Bundle "fugitive.vim"
Bundle "http://github.com/mattn/gist-vim.git"

" (HT|X)ml tool
Bundle "ragtag.vim"
Bundle "matchit.zip"

" Utility
Bundle "repeat.vim"
Bundle "surround.vim"
"Bundle "SuperTab"
Bundle "file-line"
Bundle "Align"

" FuzzyFinder
Bundle "L9"
Bundle "FuzzyFinder"
let g:fuf_modesDisable = []

" Zoomwin
Bundle "ZoomWin"

" Ack
Bundle "ack.vim"

" tComment
Bundle "tComment"

"" Command-T
"" Bundle "git://git.wincent.com/command-t.git"
" let g:CommandTMatchWindowAtTop=1 " show window at top

" Navigation
Bundle "http://github.com/gmarik/vim-visual-star-search.git"

" Compl
Bundle "AutoComplPop"

filetype plugin indent on
" " }}}


" Key mappings " {{{
let maplocalleader = ','

"nnoremap <silent> <LocalLeader>rs :source ~/.vimrc<CR>
"nnoremap <silent> <LocalLeader>rt :tabnew ~/.vim/vimrc<CR>
"nnoremap <silent> <LocalLeader>re :e ~/.vim/vimrc<CR>
"nnoremap <silent> <LocalLeader>rd :e ~/.vim/ <CR>
"nnoremap # :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
"nnoremap * #
" only non-terminal
nnoremap <silent> <S-CR> A<CR><ESC>
"" Control+S and Control+Q are flow-control characters: disable them in your terminal settings.
"" $ stty -ixon -ixoff
"noremap <C-S> :update<CR>
"vnoremap <C-S> <C-C>:update<CR>
"inoremap <C-S> <C-O>:update<CR>

nnoremap          <LocalLeader>j :!rspec -b %<CR>

" fileencoding
nnoremap <silent> <LocalLeader>u :set fileencoding=utf-8<CR>
nnoremap <silent> <LocalLeader>s :set fileencoding=cp932<CR>
nnoremap <silent> <LocalLeader>e :set fileencoding=euc-jp<CR>

" Fuf
nnoremap <silent> <LocalLeader>f :FufFile<CR>
nnoremap <silent> <LocalLeader>b :FufBuffer<CR>
nnoremap <silent> <LocalLeader>F :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <LocalLeader><C-f> :FufMruFile<CR>
nnoremap <silent> <LocalLeader>c :FufMruCmd<CR>
nnoremap <silent> <LocalLeader>l :FufLine<CR>

" Ack
noremap  <LocalLeader># "ayiw:Ack <C-r>a<CR>
vnoremap <LocalLeader># "ay:Ack <C-r>a<CR>

" tComment
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" poslist
nnoremap          <C-J> <Plug>(poslist-next-pos)
nnoremap          <C-K> <Plug>(poslist-prev-pos)

" Split line
nnoremap <silent> <C-S-J> gEa<CR><ESC>ew 

nnoremap          <LocalLeader>o :ZoomWin<CR>
vnoremap          <LocalLeader>o <C-C>:ZoomWin<CR>
inoremap          <LocalLeader>o <C-O>:ZoomWin<CR>
nnoremap          <C-W>+o :ZoomWin<CR>

" Duplicate
vnoremap <silent> <LocalLeader>= yP
nnoremap <silent> <LocalLeader>= YP

" Tabs 
"nnoremap <silent> <LocalLeader>[ :tabprev<CR>
"nnoremap <silent> <LocalLeader>] :tabnext<CR>

" Delete Buffer
nnoremap <silent> <LocalLeader>- :bd<CR>

" Split window
noremap  <silent> <C-W>v :vnew<CR>
noremap  <silent> <C-W>s :snew<CR>

" show/Hide hidden Chars
"map <silent> <F12> :set invlist<CR>     

" generate HTML version current buffer using current color scheme
noremap  <silent> <LocalLeader>2h :runtime! syntax/2html.vim<CR> 
" " }}}


" set username, password, etc...
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

