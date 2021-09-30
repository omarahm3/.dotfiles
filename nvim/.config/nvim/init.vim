" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()
	" This for auto complete, prettier and tslinting
	Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }
	let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed

	Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

	" these two plugins will add highlighting and indenting to JSX and TSX files.
	Plug 'yuezk/vim-js'
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'maxmellon/vim-jsx-pretty'
	Plug 'preservim/nerdtree'
	Plug 'dense-analysis/ale'
	Plug 'mattn/emmet-vim'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
	Plug 'scrooloose/nerdcommenter'
	Plug 'sheerun/vim-polyglot'
	Plug 'vim-airline/vim-airline'
	Plug 'Yggdroot/indentLine'
	Plug 'tomasiser/vim-code-dark'
  Plug 'sonph/onehalf', { 'rtp': 'vim' }
  Plug 'chr4/nginx.vim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'luochen1990/rainbow'
  Plug 'tpope/vim-fugitive'
  Plug 'voldikss/vim-floaterm'
  Plug 'tpope/vim-surround'
  Plug 'mhinz/vim-startify'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'arcticicestudio/nord-vim'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
call plug#end()

let g:coc_node_path = '/home/mrgeek/.local/share/nvm/v16.3.0/bin/node'
let g:coc_npm_path = '/home/mrgeek/.local/share/nvm/v16.3.0/bin/npm'

let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]

let g:startify_session_autoload = 1

" " FZF RG searches for filename in addition to the phrase, this to skip this issue
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --hidden --no-ignore --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" " Show Markdown symbols
set conceallevel=0
set mouse=a
" " Show line numbers
set number
set hidden
set cursorline
set expandtab
set autoindent
set smartindent
set encoding=utf8
set history=5000
" " Make sure that indentation is 2 spaces
set tabstop=2
set shiftwidth=0
set cindent
let g:tokyonight_style = "storm"
let g:airline_theme='onehalfdark'
"colorscheme onehalfdark
colorscheme tokyonight

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nmap <leader>gs :G<CR>

" " NerdTree toggle shortcut
nnoremap <silent> <C-k>b :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['^node_modules$']

"	" open NERDTree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree

" " sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" " file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" " Open Fuzzy finder
nmap <C-s> :Startify<CR>

" " Open Fuzzy finder
nmap <C-p> :Telescope find_files theme=get_dropdown<CR>

" " Open RipGrep
nmap <C-A-p> :Rg<CR>

" " Open list git commits
nmap <leader>gc :Telescope git_commits theme=get_dropdown<CR>

" " Open list git branches
nmap <leader>gb :Telescope git_branches theme=get_dropdown<CR>

" " List stash items
nmap <leader>gt :Telescope git_stash theme=get_dropdown<CR>

" " Floaterm toggle key
let g:floaterm_keymap_toggle = '<C-t>'

let g:floaterm_position = 'bottomright'

" " Activate rainbow
let g:rainbow_active = 1

" " ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-go',
  \ ]
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" " Enable folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
