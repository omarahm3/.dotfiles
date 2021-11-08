" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()
	" This for auto complete, prettier and tslinting
	Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }

  "this will auto close ( [ {
	Plug 'jiangmiao/auto-pairs'

	Plug 'preservim/nerdtree'
	Plug 'dense-analysis/ale'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
	Plug 'scrooloose/nerdcommenter'
	Plug 'sheerun/vim-polyglot'
	Plug 'vim-airline/vim-airline'
	Plug 'Yggdroot/indentLine'
  Plug 'chr4/nginx.vim'
  " 'plenary' is required by Telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'luochen1990/rainbow'
  Plug 'tpope/vim-fugitive'
  Plug 'voldikss/vim-floaterm'
  Plug 'tpope/vim-surround'
  Plug 'mhinz/vim-startify'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'sonph/onehalf', { 'rtp': 'vim' }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'wfxr/minimap.vim'
  Plug 'ThePrimeagen/harpoon'
call plug#end()

" ################# MISC #################

" " FZF RG searches for filename in addition to the phrase, this to skip this issue
"command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

colorscheme tokyonight

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" ################# Setters #################

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
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" " Enable folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" ################# Functions #################

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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

" ################# inoremaps #################

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ################# nnoremaps #################

" " Copy to clipboard
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy  "+yy
" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
" " NerdTree toggle shortcut
nnoremap <silent> <C-k>b :NERDTreeToggle<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" ################# vnoremaps #################

" " Copy to clipboard
vnoremap  <leader>y  "+y
" " Paste from clipboard
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" ################# nmaps #################

nmap <leader>gs :G<CR>
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
" Remap for format selected region
nmap <leader>f  <Plug>(coc-format-selected)

nmap <leader>a  :lua require("harpoon.mark").add_file()<CR>

nmap <leader>h  :lua require("harpoon.ui").toggle_quick_menu()<CR>

" ################# letters #################

let g:coc_node_path = '~/.local/share/nvm/v16.3.0/bin/node'
let g:coc_npm_path = '~/.local/share/nvm/v16.3.0/bin/npm'
let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   Files']            },
  \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ ]
let g:startify_session_autoload = 1
let g:tokyonight_style = "storm"
let g:airline_theme="onehalfdark"
let g:NERDTreeIgnore = ['^node_modules$']
" " AutoPair toggle key
let g:AutoPairsShortcutToggle = '<F2>'
" " Floaterm toggle key
let g:floaterm_keymap_toggle = '<C-t>'
let g:floaterm_position = 'bottomright'
" " Activate rainbow
let g:rainbow_active = 1
" COC config
let g:coc_global_extensions = [
  \ 'coc-tslint-plugin',
  \ 'coc-snippets',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-prettier',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-go',
  \ ]

" ################# autocmds #################

"	" open NERDTree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
