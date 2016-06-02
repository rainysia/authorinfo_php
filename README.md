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
let g:vimrc_lang_version=' version $num'

nmap <F4> :AuthorInfoDetect<cr>
```

## Others
------------------------------
You may want to add bash,python,c,java header automatically when vim create, add the below snippets into your vimrc.

e.g.: vim test.php, vim test.py, vim test.sh etc.
```
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py,*.php exec ":call SetTitle()" 
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."), "")
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# -*- coding: UTF-8 -*-")
        call append(line(".")+1, "")
    elseif &filetype == 'php'
        call setline(1,"<?php")
        call append(line("."), "")
    else 
        call setline(1, "/*************************************************************************")
        call append(line("."), "	> File Name: ".expand("%"))
        call append(line(".")+1, "	> Author: Yourname")
        call append(line(".")+2, "	> Mail: EmailAddress")
        call append(line(".")+3, "	> Created Time: ".strftime("%F %T"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
    endif
    if &filetype == 'java'
    	call append(line(".")+6,"public class ".expand("%"))
    	call append(line(".")+7,"")
    endif
endfunc
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
2016-06-02 17:20:43 Update Authorinfo for PHP</br >



