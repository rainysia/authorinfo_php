if exists('g:loaded_authorinfo')
    finish
endif
let g:loaded_authorinfo  = 1
let g:vimrc_lang_version = exists('g:vimrc_lang_version') ? g:vimrc_lang_version : ' version num'
let g:vimrc_author       = exists('g:vimrc_author')     ? g:vimrc_author : ' Author'
let g:vimrc_email        = exists('g:vimrc_email')      ? g:vimrc_email : ' author@xxx.com'
let g:vimrc_copyright    = exists('g:vimrc_copyright')  ? g:vimrc_copyright : ' Copyright'
let g:vimrc_license      = exists('g:vimrc_license')    ? g:vimrc_license : 'https://opensource.org/licenses/MIT license'
let g:vimrc_version      = exists('g:vimrc_version')    ? g:vimrc_version : 'GIT: 0.0.1'
let g:vimrc_link         = exists('g:vimrc_link')       ? g:vimrc_link : 'http://xxx.com'

if exists("mapleader")
    let s:t_mapleader = mapleader
elseif exists("g:mapleader")
    let s:t_mapleader = g:mapleader
else
    let s:t_mapleader = '\'
endif

function! g:CheckFileType(type)
    let t_filetypes = split(&filetype,'\.')
    if index(t_filetypes,a:type)>=0
        return 1
    else
        return 0
    endif
endfunction
function s:DetectFirstLine()
    exe 'normal '.1.'G'
    let arrData = [
                \['sh',['^#!.*$']],
                \['lua',['^#!.*$']],
                \['perl',['^#!.*$']],
                \['python',['^#!.*$','^#.*coding:.*$']],
                \['ruby',['^#!.*$','^#.*encoding:.*$']],
                \['php',['^<?.*']]
                \]
    let oldNum = line('.')
    while 1
        let line = getline('.')
        let findMatch = 0
        for [t,v] in arrData
            if g:CheckFileType(t)
                for it in v
                    if line =~ it
                        let findMatch = 1
                        break
                    endif
                endfor
            endif
        endfor
        if findMatch != 1
            break
        endif
        normal j
        if oldNum == line('.')
            normal o
            return
        endif
        let oldNum = line('.')
    endwhile
    normal O
endfunction
function s:BeforeTitle()
    let arrData = [['python',"'''"]]
    for [t,v] in arrData
        if g:CheckFileType(t)
            call setline('.',v)
            normal o
            break
        endif
    endfor
endfunction
function s:AfterTitle()
    let arrData = [['python',"'''"]]
    for [t,v] in arrData
        if g:CheckFileType(t)
            normal o
            call setline('.',v)
            normal k
            break
        endif
    endfor
endfunction
function s:AddTitle()
    call s:DetectFirstLine()
    let hasMul = 0
    let preChar = ' '
    let noTypeChar = '*'

    call setline('.','test mul')
    let oldline = getline('.')
    exec 'normal '.s:t_mapleader.'cm'
    let newline = getline('.')
    if oldline != newline
        let hasMul = 1
        let preChar = ' '
    else
        exec 'normal '.s:t_mapleader.'cl'
        let newline = getline('.')
        if oldline == newline
            let hasMul = -1
            let noTypeChar = '*'
        endif
    endif

    call s:BeforeTitle()

    let firstLine = line('.')
    let upperFiletype=toupper(&filetype)
    if upperFiletype ==# 'SH'
        let upperFiletype = 'BASH'
    elseif upperFiletype ==# 'PHP'
        let upperFiletype = 'PHP'
    elseif upperFiletype ==# 'PYTHON'
        let upperFiletype = 'PYTHON'
    endif

    call setline('.',noTypeChar)
    normal o
    call setline('.',preChar.noTypeChar.preChar.'Short description for file')
    normal o
    normal o
    call setline('.',preChar.noTypeChar.preChar.upperFiletype.g:vimrc_lang_version)
    let gotoLn = line('.')
    normal o
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@filename   '.expand("%:t"))
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@category   '.'CategoryName')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@package    '.'PackageName')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@author     '.g:vimrc_author.preChar.'<'.g:vimrc_email.'>')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@copyright  '.g:vimrc_copyright)
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@license    '.g:vimrc_license)
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@version    '.g:vimrc_version)
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@createTime '.strftime("%Y-%m-%d %H:%M:%S"))
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@lastChange '.strftime("%Y-%m-%d %H:%M:%S"))
    normal o
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@link '.g:vimrc_link)
    normal o
    call setline('.',preChar.noTypeChar)

    let lastLine = line('.')

    call s:AfterTitle()

    if hasMul == 1
        exe 'normal '.firstLine.'Gv'.lastLine.'G'.s:t_mapleader.'cm'
    else
        exe 'normal '.firstLine.'Gv'.lastLine.'G'.s:t_mapleader.'cl'
    endif

    exe 'normal '.gotoLn.'G'
    startinsert!

    echohl WarningMsg | echo "Succ to add the copyright." | echohl None
endf
function s:TitleDet()
    silent! normal ms
    let updated = 0
    let n = 1
    while n < 30
        let line = getline(n)
        if line =~ '^.*filename\S*.*$'
            let newline=substitute(line,'filename\(\s*\)\(\S.*$\)$','filename\1'.expand("%:t"),'g')
            call setline(n,newline)
            let updated = 1
        endif
        if line =~ '^.*lastChange\S*.*$'
            let newline=substitute(line,'lastChange\(\s*\)\(\S.*$\)$','lastChange\1'.strftime("%Y-%m-%d %H:%M:%S"),'g')
            call setline(n,newline)
            let updated = 1
        endif
        let n = n + 1
    endwhile
    if updated == 1
        silent! normal 's
        echohl WarningMsg | echo "Succ to update the copyright." | echohl None
        return
    endif
    call s:AddTitle()
endfunction
command! -nargs=0 AuthorInfoDetect :call s:TitleDet()
