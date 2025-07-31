" =============================================================================
" COMPREHENSIVE VIMRC CONFIGURATION
" =============================================================================
" Author: Grigore Casim
" Last Updated: May 20, 2025
" Compatible with Vim 8.0+ and Neovim
" =============================================================================

" -----------------------------------------------------------------------------
" GENERAL SETTINGS
" -----------------------------------------------------------------------------
set nocompatible                 " Use Vim defaults instead of 100% vi compatibility
filetype plugin indent on        " Enable file type detection and do language-dependent indenting
syntax enable                    " Enable syntax highlighting
set encoding=utf-8               " Set default encoding to UTF-8
set fileencoding=utf-8           " Default file encoding
set fileformat=unix              " Default file format
set hidden                       " Enable hidden buffers
set autoread                     " Auto-reload files changed outside of Vim
set ttyfast                      " Speed up scrolling in Vim
set updatetime=300               " Faster completion with shorter updatetime
set timeout timeoutlen=500       " Set timeout for key codes
set history=1000                 " Remember more commands and search history
set undolevels=1000              " Use many levels of undo
set backspace=indent,eol,start   " Allow backspacing over everything in insert mode
set showmatch                    " Briefly jump to matching bracket upon bracket insertion
set matchtime=2                  " Time to show matching paren
set noshowmode                   " Don't show current mode (use airline/lightline instead)
set lazyredraw                   " Don't update screen during macro/script execution
set noerrorbells                 " No sound on errors
set novisualbell                 " No flashing screen on errors
set t_vb=                        " No visual bell

" -----------------------------------------------------------------------------
" VIM DIRECTORIES FOR SWAP, UNDO, AND BACKUP
" -----------------------------------------------------------------------------
" Keep swap files in one location
set directory=$HOME/.vim/tmp//,.
" Keep undo files in one location
if has('persistent_undo')
    set undodir=$HOME/.vim/undo//,.
    set undofile
endif
" Keep backup files in one location
set backup
set backupdir=$HOME/.vim/backup//,.

" -----------------------------------------------------------------------------
" APPEARANCE SETTINGS
" -----------------------------------------------------------------------------
set termguicolors               " Enable true colors support
colorscheme desert              " Default color scheme (change as desired)
set background=dark             " Use dark background
set number                      " Show line numbers
set relativenumber              " Use relative line numbers
set cursorline                  " Highlight current line
set signcolumn=yes              " Always show signcolumn
set colorcolumn=80,120          " Highlight column 80 and 120
set ruler                       " Show cursor position
set showcmd                     " Show incomplete commands
set laststatus=2                " Always show status line
set scrolloff=8                 " Minimum number of screen lines above/below cursor
set sidescrolloff=8             " Minimum number of screen columns to keep to left/right of cursor
set shortmess+=c                " Don't pass messages to |ins-completion-menu|
set splitbelow                  " Split below current window
set splitright                  " Split window to the right
set list                        " Show trailing whitespace
set listchars=tab:→\ ,trail:·,extends:»,precedes:«,nbsp:+
set title                       " Change terminal title based on file being edited

" -----------------------------------------------------------------------------
" SEARCH SETTINGS
" -----------------------------------------------------------------------------
set hlsearch                    " Highlight search results
set incsearch                   " Incremental search
set ignorecase                  " Ignore case when searching
set smartcase                   " Override ignorecase if search pattern has uppercase
set wrapscan                    " Wrap around when searching

" Clear search highlights with <leader><space>
nnoremap <silent> <leader><space> :noh<CR>

" -----------------------------------------------------------------------------
" INDENTATION AND FORMATTING
" -----------------------------------------------------------------------------
set autoindent                  " Copy indent from current line when starting a new line
set smartindent                 " Smart autoindenting when starting a new line
set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Tab width is 4 spaces
set shiftwidth=4                " Indent with 4 spaces
set softtabstop=4               " Number of spaces in tab when editing
set shiftround                  " Round indentation to nearest multiple of shiftwidth
set smarttab                    " <Tab> in front of a line inserts 'shiftwidth' spaces
set textwidth=0                 " Don't break lines automatically
set nowrap                      " Don't wrap long lines
set linebreak                   " If wrapping is enabled, wrap at word boundaries

" Use 2 spaces for specific file types
augroup FiletypeSpecificIndentation
    autocmd!
    autocmd FileType html,css,javascript,typescript,yaml,json,ruby,eruby,markdown,vim setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" -----------------------------------------------------------------------------
" COMPLETION SETTINGS
" -----------------------------------------------------------------------------
set wildmenu                    " Visual autocomplete for command menu
set wildmode=longest:full,full  " Command-line completion mode
set completeopt=menuone,noinsert,noselect,preview
set complete+=kspell            " Autocomplete with dictionary when spell check is on

" Exclude files from completions
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.pyd,*.class,*.so,*.swp,*.zip,*.tar,*.tar.gz,*.tgz
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.bmp,*.ico
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" -----------------------------------------------------------------------------
" FOLDING SETTINGS
" -----------------------------------------------------------------------------
set foldenable                  " Enable folding
set foldmethod=indent           " Fold based on indentation
set foldlevelstart=10           " Open most folds by default
set foldnestmax=10              " Maximum nested folds

" Use space to toggle folds
nnoremap <space> za

" -----------------------------------------------------------------------------
" KEY MAPPINGS
" -----------------------------------------------------------------------------
" Set leader key to comma
let mapleader = ","
let maplocalleader = "\\"

" Quickly edit/reload the vimrc file
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>:echo "vimrc reloaded!"<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move between buffers
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bd :bd<CR>

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Keep selection after indent
vnoremap < <gv
vnoremap > >gv

" Save with Ctrl-S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Center cursor when moving up/down
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Quickfix shortcuts
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>

" -----------------------------------------------------------------------------
" NETRW SETTINGS (BUILT-IN FILE BROWSER)
" -----------------------------------------------------------------------------
let g:netrw_banner = 0          " Hide banner
let g:netrw_liststyle = 3       " Tree view
let g:netrw_browse_split = 4    " Open in previous window
let g:netrw_altv = 1            " Open splits to the right
let g:netrw_winsize = 25        " Width of netrw window
" Toggle Lexplore with <leader>e
nnoremap <leader>e :Lexplore<CR>

" -----------------------------------------------------------------------------
" PLUGIN SETTINGS (IF INSTALLED)
" -----------------------------------------------------------------------------
" If vim-plug is installed, add your plugins here
if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/plugged')

    " Color schemes
    Plug 'morhetz/gruvbox'
    Plug 'dracula/vim'
    Plug 'tomasr/molokai'
    Plug 'joshdick/onedark.vim'

    " General functionality
    Plug 'tpope/vim-surround'         " Quoting/parenthesizing made simple
    Plug 'tpope/vim-commentary'       " Comment stuff out
    Plug 'tpope/vim-repeat'           " Enable repeating supported plugin maps
    Plug 'tpope/vim-fugitive'         " Git wrapper
    Plug 'airblade/vim-gitgutter'     " Git diff in the gutter
    Plug 'vim-airline/vim-airline'    " Status line
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/fzf'               " Fuzzy finder
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree'         " File explorer
    Plug 'jiangmiao/auto-pairs'       " Insert/delete brackets in pairs

    " Development
    Plug 'sheerun/vim-polyglot'       " Language pack
    Plug 'dense-analysis/ale'         " Linting
    Plug 'SirVer/ultisnips'           " Snippets
    Plug 'honza/vim-snippets'         " Snippet library

    call plug#end()

    " Plugin-specific configurations

    " Gruvbox
    if isdirectory(expand("~/.vim/plugged/gruvbox"))
        let g:gruvbox_contrast_dark = 'medium'
        let g:gruvbox_italic = 1
        colorscheme gruvbox
    endif

    " NERDTree
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
        nnoremap <leader>n :NERDTreeToggle<CR>
        let NERDTreeShowHidden = 1
    endif

    " FZF
    if isdirectory(expand("~/.vim/plugged/fzf.vim"))
        nnoremap <leader>f :Files<CR>
        nnoremap <leader>b :Buffers<CR>
        nnoremap <leader>g :Rg<CR>
    endif

    " Airline
    if isdirectory(expand("~/.vim/plugged/vim-airline"))
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1
    endif

    " ALE
    if isdirectory(expand("~/.vim/plugged/ale"))
        let g:ale_linters = {
            \ 'python': ['flake8', 'pylint'],
            \ 'javascript': ['eslint'],
            \ }
        let g:ale_fixers = {
            \ 'python': ['black', 'isort'],
            \ 'javascript': ['prettier', 'eslint'],
            \ }
        let g:ale_fix_on_save = 1
    endif

    " COC
    if isdirectory(expand("~/.vim/plugged/coc.nvim"))
        " Use tab for trigger completion with characters ahead and navigate
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use <c-space> to trigger completion
        inoremap <silent><expr> <c-space> coc#refresh()

        " GoTo code navigation
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction
    endif
endif

let g:coc_disable_startup_warning = 1
" -----------------------------------------------------------------------------
" AUTOCOMMANDS
" -----------------------------------------------------------------------------
augroup vimrc_autocmds
    autocmd!
    " Return to last edit position when opening files
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " Auto save on focus lost
    autocmd FocusLost * :wa

    " Automatically remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Set syntax highlighting for specific file types
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
    autocmd BufRead,BufNewFile Dockerfile* set filetype=dockerfile

    " Auto-reload vimrc on save
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " Open help in vertical split
    autocmd FileType help wincmd L
augroup END

" -----------------------------------------------------------------------------
" PROGRAMMING LANGUAGE SPECIFIC SETTINGS
" -----------------------------------------------------------------------------
" Python
augroup filetype_python
    autocmd!
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType python setlocal textwidth=88
    autocmd FileType python setlocal colorcolumn=88
augroup END

" JavaScript/TypeScript
augroup filetype_javascript
    autocmd!
    autocmd FileType javascript,typescript,typescriptreact,javascriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType javascript,typescript,typescriptreact,javascriptreact setlocal colorcolumn=80
augroup END

" Golang
augroup filetype_go
    autocmd!
    autocmd FileType go setlocal noexpandtab
    autocmd FileType go setlocal tabstop=4 shiftwidth=4

