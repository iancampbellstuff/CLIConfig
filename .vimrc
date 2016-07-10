set nocompatible
set mouse=a				" mouse support
set encoding=utf8
set ai					" auto indent
set si					" smart indent
set smarttab
set nowrap				" disable text wrapping
set backspace=indent,eol,start		" backspace handling
set nostartofline			" disable auto cursor placement
filetype on				" filetype recognition
filetype plugin on			" filetype features
filetype indent plugin on
syntax enable				" syntax highlighting
syntax on
set number				" line numbers
set ruler				" show row and column position
set background=dark			" background color
set hlsearch				" highlight search results
set showmatch
set incsearch				" incremental search
set ignorecase				" case-insensitive search
set smartcase				" case-sensitivity ai
set magic				" regex searching
set noerrorbells			" disable error sound
set novisualbell			" disable visual error
set t_vb=				" disable screen flash on error
set wildmenu				" command completion help
set wildmode=longest:list:longest	" expand wildmenu
set laststatus=2			" always display the status bar
set showcmd				" show command in status bar
set cmdheight=2				" command status bar height
set confirm				" prompt to save changes on q
