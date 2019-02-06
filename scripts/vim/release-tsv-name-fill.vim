function! ReleaseTSVNameFillFunction()
  " silent! let @z = 'yypk$T	ldwguiw"ayawdd +,/\(^$\|\%$\)/-s/.*/&a'
  silent! g/^\d\{4}-\d\{2}-\d\{2}\t/normal @z
endfunction

command! ReleaseTSVNameFill call ReleaseTSVNameFillFunction()
