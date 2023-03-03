"let g:python_recommended_style = 0 " Avoid python syntax replace tab with spaces
filetype plugin indent on
syntax on
/bin/bash: vimgrep: command not found
"set clipboard=unnamedplus

set number

" Tabs --------------------------------------{{{
" Set the tab size in spaces
let myTabSizeInSpaces=2
" set existing tab width
let &tabstop = myTabSizeInSpaces
" set width for indenting with >
let &shiftwidth = myTabSizeInSpaces
" Display tabs as >----
set list
set listchars=tab:>-
"}}}

" How to handle tabs
" [200~foldlevelstart

" Grep with vim


"--------------- Vim scripting nodes ----------------
" Folds --------------------------------{{{
" Set usage of folds: setlocal foldmethod=marker
" fold/unfold with za
" fold all with zM
" unfold all with zR
" }}}

" Status line ----------------------------{{{
set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
"}}}

" Save messages to :messages ------------------{{{
"== Save messages to :messages  (for debug of vim scripts)
echom "foo"
"}}}

" Map keys ---------------------------------{{{
" map - to x
"Normal mode and visual mode:  :map - x 
"Normal mode:  :nmap - x 
"Visual mode:  :vmap - x 
"Insert mode:  :imap - x 
"
"Or even better (not dependent on maped keys or recursion)
"Normal mode and visual mode:  :noremap - x 
"Normal mode:  :nnoremap - x 
"Visual mode:  :vnoremap - x 
"Insert mode:  :inoremap - x 
"

" seldom used characters in normalmode: 
" - H L <space> <cr> <bs>
"
" special characters:
" <esc>, <space>, <c-x> (ctrl + x), <leader>
"

" Set leader key to , (will mask , as undo of tTfF movements (find/till specified char)
"let mapleader = ","
let mapleader = ","
let maplocalleader = ","

" Delete key in insert mode
inoremap <c-x> <esc>lxi

" <c-u> UPPERCASE word
inoremap <c-u> <esc>viwUea
nnoremap <c-u> mzviwU`z
nnoremap <c-l> mzviwu`z
nnoremap <leader>u viwU
inoremap <c-l> <esc><right>a
inoremap <c-h> <esc>i
inoremap <c-j> <esc><down>a
inoremap <c-k> <esc><up>a

" Edit .vimrc file quickly
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Use jk instead of <ESC> to enter normal mode
inoremap jk <ESC>
" Disable old enter insert mode to learn the key
inoremap <esc> <nop>
"}}}

" Abriviations (typo fix and quick insert) {{{
"iabbrev adn and    " Changes adn to and in insert mode (typo fix)

"=========================================================
"== Buffer local options and mappings
"nnoremap <buffer> <leader>x dd,   a mapping that only applies in the current
"                                  buffer
"nnoremap <buffer> <localleader>x dd, BETTER, use localleader for this!!
"iabbrev <buffer> ... \dots  " Also possible with local abreviations
"}}}

" Autocommands -------------------------{{{
" General nodes -----------------------{{{
"== Autocommands: Run certain command when events happen
"NOTE: Add auto commands in augroups to be able avoid multiple define when
"      resource .vimrc
"autocmd BufNewFile * :write     " autocmd <event> <eventFilterPattern> <cmd>
"Some events: FileType (when filetype is set), BufNewFile (creating new file),
"             BufRead (opening exising file)
" }}}

" Perl file settings-------------------------{{{
augroup filetype_perl
	autocmd!
	autocmd FileType perl :iabbrev <buffer> iff if ()<left>
	autocmd FileType perl nnoremap <buffer> <localleader>c I#<esc>
augroup END
" }}}

" Python file settings -------------------------{{{
"augroup filetype_python
	"autocmd!
	"autocmd FileType python :iabbrev <buffer> iff if:<left>
	"autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
"augroup END
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	autocmd FileType vim setlocal foldlevelstart=0
	autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
augroup END
" }}}
" }}}

" Operator-Pending Mappings --------------------{{{
" Combine operator and movement to operate on text in vim.
"
" Possible to create your own operator-pending mapping (movement for operators)
" Define: onoremap newKey movement   (onoremap jr i")
" Use: newKey operator    (jr d)

"}}}



" Variables and options -------------{{{
" Set variables/options/registers: ---------{{{
let myvar = "my first variable"
echo myvar

let myvar = 496
echo myvar

" Set option
set textwidth=80
echo &textwidth

" Set option as variable (to be able to use function or expression to set value)
let &textwidth = &textwidth + 20
set textwidth?

" Set Local options
"let &l:number = 0

" Set register as variable
"let @a = "hello!"
"echo @a
"
" Yank line and echo clipboard register
"yy
"echo @"
"
" Search for something and echo search pattern
" NOTE: one can now progrematically change what to search for: let @/ = 12
" /searchPattern
" echo @/
"
"}}}

" Variable scoping ------------------{{{
" Different scopes:
" b = buffer
" w = window
" t = tab
" g = global
" l = function
" s = sourced vim script
" v = global, predefined by vim
"
" E.g.
" let b:hello = "world"      set variable local to buffer
" }}}

" Different variable types ------------------------------------------{{{
" Numbers: Integer: 100 (ten based), 0xff (hexadecimal), 0132 (octadecimal)
"                   division: 4/3 = 1,  4/3.0 = 1.33333
"          Float: 100.1, 5.43e+3,    NOT: 5e3 
" String: "Hello world"
"         concatination: "Hello" . "world"
"         literal string: 'hello world'
"                         'he''s hand was...' -->  he's hand was...  ('' is only special char in
"                         literal string)
"                         
" }}}

" 
" }}}

" Conditionals ----------------------------------------------{{{
if 0
	echo "Not printed"
elseif "aString"
	echo "Not printed"
else
	echo "Printed"
endif

" Comparing:
" 1 --> true
" !0 --> true
" 10 > 1 --> true
" 10 == 10 --> true
" "foo" == "foo" --> true
"
" 0 --> false
" !1 --> false
" 10 < 1 --> false
" 10 != 10 --> false
" 10 == 11 --> false
" "foo" == "FOO" --> false   DANGER: depends on set ignorecase
" 
" ==?  --> case insensitive == check. NEVER use == 
" ==#  --> case senestive == check
" 

" }}}

" Functions in vim -----------------------{{{
function MyFunction(param1)
	echo "Input params are scoped using a:param, param: " . a:param1
	if a:param1 ==# 1
	  echo "All functions should start with capital letters"
	elseif a:param1 ==# 2
		return "Function can have return values" 
	endif
endfunction

function MyVarArgsFunc(...)
	echo "Functions can have variable number of in parameters"
	echo "first arg: " . a:0
	echo "second arg: " . a:1
	echo "all args: " . string(a:000)
endfunction

call MyFunction(1)
echo MyFunction(2)
call MyVarArgsFunc(1, 2, 3, 496, "myString")

" }}}

" Execute ------------------------------{{{
" execute command executes a string as if it was a vimscript command
" e.g. open last buffer in split window:
"  :execute "rightbelow vsplit " . bufname("#")
" }}}
  
" :normal and :!normal -----------------{{{
" :normal <key> <key2> ...    Executes keys as if in normal mode (mappings included)
" :!normal ... Executes keys without using existing key mappings
" }}}

if &diff
	colorscheme elflord2
endif

nnoremap <leader><tab> :set listchars=tab:>-

" Possible a crude way of loading 
" my vim plugins... but for now it works.
source ~/.vim/plugins/filepreview.vim
