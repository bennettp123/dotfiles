syntax on
colorscheme default
set background=light

" highlight search results
set hlsearch

" show line numbers
set number
highlight clear LineNr
highlight LineNr ctermfg=DarkGrey

" show cursor line
set cursorline
highlight clear CursorLine
highlight CursorLine ctermbg=235 ctermfg=NONE

" highlight matching parents
set showmatch

" column ruler
" set colorcolumn=81,101
" highlight ColorColumn ctermbg=DarkGrey

" status line
set laststatus=2
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
