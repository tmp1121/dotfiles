" Shougo/dein.vim
""""""""""""""""""""""""""""""
" http://qiita.com/delphinus/items/00ff2c0ba972c6e41542
""""""""""""""""""""""""""""""
" vimrc に以下のように追記

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml('~/.vim/rc/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/rc/deinlazy.toml', {'lazy' : 1})
  if has('nvim')
    call dein#load_toml('~/.vim/rc/deineo.toml', {})
  endif

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
""""""""""""""""""""""""""""""

" Shougo/neosnippet
"""""""""""""""""""""""""""""
"imap <silent>L     <Plug>(neosnippet_jump_or_expand)
"smap <silent>L     <Plug>(neosnippet_jump_or_expand)
"xmap <silent>L     <Plug>(neosnippet_expand_target)

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#expand_word_boundary = 1

let g:neosnippet#snippets_directory = '~/.vim/snippets'
"""""""""""""""""""""""""""""

" Status Line
"""""""""""""""""""""""""""""
" ファイル名表示
set statusline=%F
" Git
set statusline+=%{fugitive#statusline()}
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" file encoding
set statusline+=[ENC=%{&fileencoding}]
" 現在行数/全行数
set statusline+=[LOW=%l/%L]
" ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2
" itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'fugitive': '%{fugitive#statusline()}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }
"""""""""""""""""""""""""""""

" scrooloose/nerdtree
"""""""""""""""""""""""""""""
nnoremap :tree :NERDTreeToggle
"""""""""""""""""""""""""""""

" kana/vim-submode
"""""""""""""""""""""""""""""
" http://nanasi.jp/articles/howto/file/expand.html
"""""""""""""""""""""""""""""
" s キーを無効化
nnoremap s <Nop>
" s[h|j|k|l] で窓移動
nnoremap sj <C-w>j
noremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" s[H|J|K|L] で窓移動&入れ替え
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
" s[n|p] でタブ移動
nnoremap sn gt
nnoremap sp gT
"
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
" 次窓へ移動
nnoremap sw <C-w>w
" 自窓を縦に最大拡張
nnoremap so <C-w>_<C-w>|
" 各窓を均等にする
nnoremap sO <C-w>=
" 新タブ作成
nnoremap st :<C-u>tabnew<CR>
" 新Unite tab作成
nnoremap sT :<C-u>Unite tab<CR>
" 縦に新窓作成
nnoremap ss :<C-u>sp<CR>
" 横に新窓作成
nnoremap sv :<C-u>vs<CR>
" 1窓終了
nnoremap sq :<C-u>q<CR>
" 全窓終了
nnoremap sQ :<C-u>bd<CR>
"
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
" s[<|>] で窓を左右拡張
" s[+|-] で窓を上下拡張
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')
"""""""""""""""""""""""""""""

" tyru/open-browser.vim
"""""""""""""""""""""""""""""
" カーソル下のURLをブラウザで開く
nnoremap <Leader>o <Plug>(openbrowser-open)
vnoremap <Leader>o <Plug>(openbrowser-open)
" ググる
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>
"""""""""""""""""""""""""""""

" vim-scripts/vim-auto-save
"""""""""""""""""""""""""""""
" すかさずファイルを自動保存
let g:auto_save = 1
"""""""""""""""""""""""""""""

" bronson/vim-trailing-whitespace
" + Tab をスペース2つに変換
""""""""""""""""""""""""""""""
noremap fw :FixWhitespace<CR>:%s/\t/  /g<CR>
""""""""""""""""""""""""""""""

" tpope/vim-fugitive
""""""""""""""""""""""""""""""
nnoremap :gs :Gstatus
nnoremap :ga :Gwrite
nnoremap :gr :Gread
nnoremap :gc :Gcommit
nnoremap :gb :Gblame
nnoremap :gd :Gdiff
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" plasticboy/vim-markdown + kannokanno/previm + tyru/open-browser.vim
""""""""""""""""""""""""""""""
" http://qiita.com/uedatakeshi/items/31761b87ba8ecbaf2c1e
""""""""""""""""""""""""""""""
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a Firefox'
nnoremap :md :PrevimOpen
""""""""""""""""""""""""""""""

" ctrlpvim/ctrlp.vim
""""""""""""""""""""""""""""""
" http://qiita.com/ahiruman5/items/4f3c845500c172a02935
""""""""""""""""""""""""""""""
let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの有効化
let g:ctrlp_funky_matchtype = 'path'

if executable('ag') " agが使える環境の場合
  let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
  let g:ctrlp_user_command='ag %s -i --hidden -g ""' " 「ag」の検索設定
endif
"""""""""""""""""""""""""""""

" mattn/sonictemplate-vim
"""""""""""""""""""""""""""""
let g:sonictemplate_vim_template_dir = [
      \ '~/.cache/sonictemplate'
      \]
"""""""""""""""""""""""""""""

" haya14busa/vim-poweryank
"""""""""""""""""""""""""""""
map <Leader>y <Plug>(operator-poweryank-osc52)
"""""""""""""""""""""""""""""