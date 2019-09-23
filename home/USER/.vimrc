" Stop pretending it's the 1970s
set nocompatible

" Ln numbers
set number

" Tab indet
set tabstop=3
set shiftwidth=3

" UTF-8 is the standard
set encoding=utf-8

" Allow local .vimrc's
set secure
if filereadable(".vimrc")
	" TODO: Improve to not source other users' vimrc files
	if $USER != "root"
		set exrc
	endif
endif

" Enable plugins
filetype plugin on

" Make ':find' much better
set path+=./**
set wildmenu

" Finding definitions using ctags
command! MakeTags !ctags -R .

" Map to all modes
func! Map(keys, rhs)
	exec 'nmap' a:keys a:rhs
	exec 'imap' a:keys '<ESC>' . a:rhs
endfunction

" Unmap annoying binds
nnoremap q: <nop>
nnoremap Q <nop>

" Stop entering visual mode on mouse clicks
set mouse-=a

" Write changes with F2
call Map('<F2>', ':w<CR>')

" Quit out (safely) with F3
call Map('<F3>', ':q<CR>')

" Write changes & quit with F4
call Map('<F4>', ':wq<CR>')

" Forcefully quit using F12
call Map('<F12>', ':q!<CR>')

" Args for runnable code
let s:run_args = ''

func EditArgs()
	call inputsave()
	let s:run_args = input('Enter run args: ')
	call inputrestore()
endfunc

" Set runnable arguments with F6
call Map('<F6>', ':call EditArgs()<CR>')

" Runnable code
func RunC()
	exec '!clear && gcc % && ./a.out ' . s:run_args . '; printf "\nExit code was $?"'
endfunc
func RunCpp()
	exec '!clear && g++ % && ./a.out ' . s:run_args . '; printf "\nExit code was $?"'
endfunc
func RunPython()
	exec '!clear && python % ' . s:run_args . '; printf "\nExit code was $?"'
endfunc
func RunJava()
	exec '!clear && javac % && java %:r' . s:run_args . '; printf "\nExit code was $?"'
endfunc
func RunHTML()
	exec '!clear && xdg-open %' . s:run_args . '; printf "Attempted to open the edited HTML file in the default browser"'
endfunc

" Run some code with F5 & Ctrl + R
autocmd FileType c call Map('<F5>', ':w<CR>:call RunC()<CR>')
autocmd FileType cpp call Map('<F5>', ':w<CR>:call RunCpp()<CR>')
autocmd FileType python call Map('<F5>', ':w<CR>:call RunPython()<CR>')
autocmd FileType java call Map('<F5>', ':w<CR>:call RunJava()<CR>')
autocmd FileType html call Map('<F5>', ':w<CR>:call RunHTML()<CR>')
call Map('<C-r>', '<F5>')

" Enable syntax highlighting
syntax on

" GUI terminal
if $TERM !~ 'linux'
	" Enable 8-bit (256) color mode
	set t_Co=256

	" Theme
	colorscheme molokai

	" Powerline
	if $SSH_TTY == '' && isdirectory('/usr/lib/python3.7/site-packages/powerline/')
		set rtp+=/usr/lib/python3.7/site-packages/powerline/bindings/vim/
		set laststatus=2
	endif
endif
