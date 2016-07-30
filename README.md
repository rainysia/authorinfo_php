authorinfo_php
================

It's a vim authorinfo for php base on [dantezhu/authorinfo](https://github.com/dantezhu/authorinfo).

I modified some function and details for php PSR code standard.

Support python,php,shell,ruby,lua,perl.

## Usage
------------------------------
Add the below snippets into your vimrc, press `<F4>` to add authorinfo. keep press `<F4>` to update.
Use `BundleInstall` to install it.
```
Bundle 'rainysia/authorinfo_php'

let g:vimrc_author='Rainy Sia'
let g:vimrc_email='rainysia#btroot.org'
let g:vimrc_link='http://www.btroot.org'
let g:vimrc_copyright='2013-2016 BTROOT.ORG' 
let g:vimrc_license='https://opensource.org/licenses/MIT license'
let g:vimrc_version='GIT: 0.0.1'
let g:vimrc_lang_version = exists('g:vimrc_lang_version') ? g:vimrc_lang_version : ' version num'

nmap <F4> :AuthorInfoDetect<cr>
```

## Others
------------------------------
You may want to add bash,python,c,java header automatically when vim create, add the below snippets into your vimrc.

e.g.: vim test.php, vim test.py, vim test.sh etc.
```
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.lua,*.py,*.php exec ":call SetTitle()" 

let g:vimrc_author='Rainy Sia'
let g:vimrc_email='rainysia@gmail.com'

function! SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."), "")
    elseif &filetype == 'python'
        let g:vimrc_lang_version=' 2.7.9'
        "let g:vimrc_lang_version=system('python --version')
        let g:snips_php_version=g:vimrc_lang_version
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# -*- coding: UTF-8 -*-")
        call append(line(".")+1, "")
    " elseif &filetype == 'mkd'
    "    call setline(1,"<head><meta charset=\"UTF-8\"></head>")
    elseif &filetype == 'php'
        let g:vimrc_lang_version=' version '.system('php -r "echo phpversion();"')
        let g:snips_php_version=g:vimrc_lang_version
        call setline(1,"<?php")
        call append(line("."), "")
    elseif &filetype == 'cpp'
        call setline(1, "#include<iostream>")
        call append(line("."), "using namespace std;")
        call append(line(".")+1, "")
    elseif &filetype == 'c'
        call setline(1, "#include <stdio.h>")
        call append(line("."), "")
    elseif &filetype == 'java'
        call setline(1,"public class ".expand("%"))
        call append(line("."),"")
    elseif &filetype == 'lua'
        let g:vimrc_lang_version=' version 5.3.3'
        let g:snips_php_version=g:vimrc_lang_version
        call setline(1,"#!/usr/local/bin/lua")
        call append(line("."), "")
    elseif &filetype == 'go'
        call setline(1,"#!/usr/local/go/bin")
        call append(line("."), "")
    else
        let g:vimrc_lang_version=' version num'
        let g:snips_php_version=g:vimrc_lang_version
        call setline(1, "/*************************************************************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "  > Author: ".g:vimrc_author)
        call append(line(".")+2, "  > Mail: ".g:vimrc_email)
        call append(line(".")+3, "  > Created Time: ".strftime("%F %T"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif
endfunction
autocmd BufNewFile * normal G
```

## Screenshot
------------------------------
![Author for PHP passed Syntastic](https://cloud.githubusercontent.com/assets/1259324/15738169/9c5069ee-28dc-11e6-8910-a1aa2edcaa5e.png)
![shell](https://cloud.githubusercontent.com/assets/1259324/15738181/ac09f62a-28dc-11e6-8778-cae084215a43.png)
![py](https://cloud.githubusercontent.com/assets/1259324/15738190/bd7b7122-28dc-11e6-9b37-915b33638eec.png)

## Contact
----------------------------------------
<rainysia@gmail.com>


### Requirements
----------------------------------------

    vim > 7.0
    vim plugins bundle


### Update
----------------------------------------
2016-04-20 10:11:49 Add Readme<br />
2016-06-02 17:20:43 Update Authorinfo for PHP<br />
2016-07-12 18:18:05 Update variables for global<br />
2016-07-31 02:02:02 Fix minial bugs<br />
