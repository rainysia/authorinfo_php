if exists('g:loaded_authorinfo')
    finish
endif
let g:loaded_authorinfo= 1

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
    "跳转到指定区域的第一行，开始操作
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
        "到了最后一行了，所以直接o就可以了
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
    "检查开始插入作者信息的行
    call s:DetectFirstLine()
    "判断是否支持多行注释
    let hasMul = 0
    let preChar = ' '
    let noTypeChar = '*'
    let dbTypeChar = '**'
	let startTag = '/'

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

    "在第一行之前做的事情
    call s:BeforeTitle()

    let firstLine = line('.')
    call setline('.',startTag.noTypeChar)
    normal o
    call setline('.',preChar.noTypeChar.preChar. expand("%:t"))
    normal o
    normal o
    "call setline('.',preChar.noTypeChar.preChar.' ')
    let gotoLn = line('.')  " 指示光标最后停留的位置
    "normal o
    "normal o
    call setline('.',preChar.noTypeChar.preChar.'@version    '.g:vimrc_version)
    normal o
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@category   ')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@package    ')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@subpackage ')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@author     '.g:vimrc_author.preChar.'<'.g:vimrc_email.'>')
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@copyright  '.g:vimrc_copyright)
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@license    '.g:vimrc_license)
    "normal o
    "call setline('.',preChar.noTypeChar.preChar.'@email:     '.g:vimrc_email)
    "normal o
    "call setline('.',preChar.noTypeChar.preChar.'@link:      '.g:vimrc_link)
    normal o
    "call setline('.',preChar.noTypeChar.preChar.'@version '.g:vimrc_version)
    "normal o
    call setline('.',preChar.noTypeChar.preChar.'@createTime '.strftime("%Y-%m-%d %H:%M:%S"))
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@lastChange '.strftime("%Y-%m-%d %H:%M:%S"))
    normal o
    normal o
    call setline('.',preChar.noTypeChar.preChar.'@link       '.g:vimrc_link)
    normal o
    normal o
    call setline('.',noTypeChar.startTag)
    let lastLine = line('.')

    "在最后一行之后做的事情
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
    "默认为添加
    while n < 20
        let line = getline(n)
        if line =~ '^.*FileName:\S*.*$'
            let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.expand("%:t"),'g')
            call setline(n,newline)
            let updated = 1
        endif
        if line =~ '^.*LastChange:\S*.*$'
            let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.strftime("%Y-%m-%d %H:%M:%S"),'g')
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
