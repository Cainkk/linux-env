
function! s:Cscope_remove_set()
    set cscopequickfix=
    au! QuickFixCmdPost cscope

endfunction

function! s:Cscope_find_method(word, op)
    "augroup! why no effect?
    au! QuickFixCmdPost cscope silent! copen

    let &cscopequickfix = a:op . "-"
    silent execute "vert scs find " a:op . " " . a:word
    "donot copen next time aumomatically
    call s:Cscope_remove_set()

endfunction

" cscope settings for vim
function! s:Cscope_nmap()
    set cscopetag
    set csto=1
    set cscopeverbose

    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function! s:name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function! s:under cursor calls

    nmap css :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap csg :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap csc :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap cst :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap cse :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap csf :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap csi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap csd :cs find d <C-R>=expand("<cword>")<CR><CR>	

    com! -nargs=? Csc call <SID>Cscope_find_method(<q-args> == "" ? expand("<cword>") : <q-args>, "c")
    com! -nargs=? Css call <SID>Cscope_find_method(<q-args> == "" ? expand("<cword>") : <q-args>, "s")
    com! -nargs=? Csd call <SID>Cscope_find_method(<q-args> == "" ? expand("<cword>") : <q-args>, "d")
    com! -nargs=? Csg call <SID>Cscope_find_method(<q-args> == "" ? expand("<cword>") : <q-args>, "g")

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

endfunction


" ############################################################
" search cscope index database under '~/.cscope' directory
" against first opened file path, OR current direcotry if no argv
" 
" project_path: record the original source code path
" ############################################################
" variable must be 'assigned' even if empty value
" variable must be 'let'ed if does appear individually
" function! s:must be 'call'ed if it doesnot exist in expresstion
" urgly to use 'fu/endf' abbreviation
" debug method
" echo l:v, OR echo function(v)
" sleep 100 (senconds, OR 100ms)
" nice snippet for using map(), filter(), v:val
"
"function! s:Get_project_list()
"    " list cscope index database
"    " ls -1: list one file per line
"    let l:idx_db_path = $HOME . "/" . ".cscope"
"    let l:prlist = split((system("ls -1 " . l:idx_db_path)), '\n')
"    if !empty(l:prlist)
"        call map(l:prlist, 'l:idx_db_path . "/" . v:val')
"        call filter(l:prlist, '!"isdirectory(" . v:val . ")"')
"        return l:prlist
"    else
"        return []
"    endif
"
"endfunction
" ############################################################

let s:IDX_DB_ROOT = $HOME . "/" . ".cscope"

function! s:Get_current_path()
    let l:curpath = fnamemodify(argv(argidx()), ":p")

    if l:curpath == ""
        let l:curpath = getcwd()
    endif

    let l:ftype = getftype(l:curpath)
    if l:ftype == "file"
        " 
        " go on even if a new file, or wrong file name:
        " if !filereadable(l:curpath)
        " 
        " get directory
        let l:curpath = fnamemodify(l:curpath, ":h")

    elseif l:ftype == "dir"
        " do nothing
    else
        " probably not in project
        return -1
    endif

    if l:curpath == ""
        return -1
    else
        return l:curpath
    endif

endfunction

function! s:Get_project_list()
    " list cscope index database
    " ls -1: list one file per line
    return split((system("ls -1 " . s:IDX_DB_ROOT)), '\n')

endfunction

function! s:Is_matched_project(cur, project)
    " support more sub dirs
    let l:num_files = 10
    let l:srcplist = readfile(a:project . "/" . "project_path", '', l:num_files)
    let l:singlep = ""
    let l:i = 0

    for l:singlep in l:srcplist
        if match(a:cur, l:singlep) != -1
            " success
            return l:i
        endif
        let l:i += 1
    endfor

    return -1

endfunction

function! s:Do_cscope_connect(project)
    if !filereadable(a:project . "/" . "cscope.out")
        return -1
    endif

    call s:Cscope_nmap()
    silent exe 'cs a ' . a:project

    let l:tag_file = a:project . "/" . "tags"
    if executable("ctags") && filereadable(l:tag_file)
        " &tags is option
        let &tags = l:tag_file
    endif

endfunction

function! s:Lookup_idx_db(cur, prlist)
    let l:p = ""
    " not the best but can use
    let l:makedo = ""

    for l:p in a:prlist
        let l:p = s:IDX_DB_ROOT . '/' . l:p
        if !isdirectory(l:p)
	    continue
        endif

        let l:ret = s:Is_matched_project(a:cur, l:p)
        if l:ret == -1
            continue
	elseif l:ret == 0
            call s:Do_cscope_connect(l:p)
            return 1
	elseif l:ret > 0
	    let l:makedo = l:p
        endif
    endfor

    if l:makedo != ""
        call s:Do_cscope_connect(l:makedo)
    endif

    return 1

endfunction


function! s:Try_cscope_connect(cur)
    let l:curpath = a:cur
    if l:curpath == -1
        return -1
    endif

    let l:prlist = []
    if empty( extend(l:prlist, s:Get_project_list()))
        return -1
    endif

    call s:Lookup_idx_db(l:curpath, l:prlist)

endfunction

function! s:Cscope_env_prepared()
    return has("cscope") && executable("cscope") == 1 && isdirectory(s:IDX_DB_ROOT)
endfunction

function! s:Start_cscope_connect(cur)
    if s:Cscope_env_prepared()
        let s:IDX_DB_ROOT = $HOME . "/" . ".cscope"
        call s:Try_cscope_connect(a:cur)
    endif
endfunction

" ###Entry ahha###
call s:Start_cscope_connect(s:Get_current_path())

au BufRead *.{c,h,s,S,cpp,lds,java} if !cscope_connection() | call <SID>Start_cscope_connect(expand("%:p:h")) | endif
com! -nargs=? Csa if !cscope_connection() | call <SID>Start_cscope_connect(<q-args> == "" ? expand("%:p:h")) : <q-args> | endif

" not need!?
" unlet! s:IDX_DB_ROOT

