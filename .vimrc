if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'w0rp/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'altercation/vim-colors-solarized'
Plug 'ervandew/supertab'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'will133/vim-dirdiff'
Plug 'OmniSharp/omnisharp-vim'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'zchee/deoplete-jedi'
call plug#end()

if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo")
endif

set viminfo='100,<1000,%
set undodir=~/.vim/undo
set undofile
set background=dark
set laststatus=2
set noshowmode
set number
set signcolumn=yes
let g:solarized_termcolors=256
colorscheme solarized

highlight clear SignColumn
highlight SignColumn guibg=black

nmap <C-p> :Files<Cr>

let g:deoplete#enable_at_startup = 1

let g:OmniSharp_server_path = '/home/ubuntu/omnisharp/omnisharp/OmniSharp.exe'
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_timeout = 3
let g:OmniSharp_stop_server = 0
set completeopt=longest,menuone,preview

" Lightline
let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_function': {
\   'readonly': 'LightlineReadonly'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

function! s:MaybeUpdateLightline()
  highlight clear SignColumn
  highlight SignColumn guibg=black
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

let g:gitgutter_override_sign_column_highlight = 0

highlight GitGutterAdd guibg=black
highlight GitGutterChange guibg=black
highlight GitGutterDelete guibg=black
highlight GitGutterChangeDelete guibg=black

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Supertab
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1

