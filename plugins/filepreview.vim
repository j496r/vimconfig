" When moving up and down with j and k, do the following:
" Parse current line, get file path from it, open buffer in preview window (not in focus)
"
" Toggle this plugin on and off using <leader>-<CR>
"
"

""" Multi inclution protection
" TODO: Enable when done
"if exists('g:loaded_filepreview')
"	finish
"endif
"let g:loaded_filepreview = 1

let s:noFile='not_a_file'
let s:noLine=0


" Display file in preview window, show at specified line, do not focus on the new buffer
function! s:openbuffer(file, line, highlight)
	let l:previewWindowID=s:getPreviewWindowId()
	let l:currWindowID=win_getid()
        " Create new preview window if it does not yet exist
	if !l:previewWindowID
		" Open new preview window
		split
                " Open folds
		normal! zR
		let w:previewWindow=1
		let l:previewWindowID=s:getPreviewWindowId()
		call s:goToWindow(l:currWindowID)
	endif
	if l:previewWindowID
		call s:goToWindow(l:previewWindowID)
		execute "view! " . a:file
		execute "normal! " . a:line . "G <CR>"
                if a:highlight
                    " Remove latest highligted line, and highlight new (current) line
                    call clearmatches()
                    call matchadd('Search', '\%'.line('.').'l')
                else
                    call clearmatches()
                endif
		normal! zz
	endif
	call s:goToWindow(l:currWindowID)
endfunction

" Get line under cursor
function! s:searchPath()
	let l:line=getline('.')
	let l:path = matchstr(l:line, '\s*\zs[-_~.a-zA-Z\/0-9]\+\ze')
	let l:lineNr = matchstr(l:line, '\s*[-_~.a-zA-Z\/0-9]\+:\zs\d\+\ze')
	if !l:lineNr
	  let l:lineNr = 1
	endif
	return [l:path, l:lineNr]
endfunction


" Check if file exist
function! s:fileExist(file)
	if a:file ==# s:noFile
		return 0
	endif
	return filereadable(expand(a:file))
endfunction

" Local function: getPreviewWindowId
" Function returning the window ID of the preview window, or 0 if not found
function! s:getPreviewWindowId()
	if s:isPreviewWindow()
		let l:previewWindowID=win_getid()
	else
		let l:previewWindowID=0
		let l:currWindowID=win_getid()
		wincmd w
		while win_getid() !=# l:currWindowID
			if s:isPreviewWindow()
				let l:previewWindowID=win_getid()
			endif
			wincmd w
		endwhile
	endif
	return l:previewWindowID
endfunction

function! s:goToWindow(windowID)
	let l:currentWindowID=win_getid()
	wincmd w
	while win_getid() !=# l:currentWindowID
		if a:windowID ==# win_getid()
			echo "Changed window to: " . win_getid()
			return
		endif
	  wincmd w
	endwhile
	echo "Did not change window, still: " . win_getid()
endfunction

function! s:isPreviewWindow()
	return exists('w:previewWindow')
endfunction


function! s:previewFileOnCurrentLine()
	let currentLineContent = <SID>searchPath()
	let l:file=currentLineContent[0]
	let l:lineNr=currentLineContent[1]
        let l:highlightPreviewLine = b:mappingsSet ==# 1
	if s:fileExist(l:file)
		call <SID>openbuffer(l:file, l:lineNr, l:highlightPreviewLine)
	endif
endfunction

function! s:toggleMappings()
	if exists("b:mappingsSet") && b:mappingsSet ==# 1
		let b:mappingsSet = 2
        elseif exists("b:mappingsSet") && b:mappingsSet ==# 2
		let b:mappingsSet = 0
		unmap <buffer> j
		unmap <buffer> k
	else
		let b:mappingsSet = 1
		silent call <SID>previewFileOnCurrentLine()
		nnoremap <buffer> j :normal! j<CR>:silent call<sid>previewFileOnCurrentLine()<CR>:echo ""<CR>
		nnoremap <buffer> k :normal! k<CR>:silent call<SID>previewFileOnCurrentLine()<CR>:echo ""<CR>
	endif
	echo "filepreview=" . b:mappingsSet
endfunction

function! NoteCurrentFileAndLine(note)
  let l:note = a:note
  if a:note ==# '.'
    let l:note = getline('.')
  endif

  let l:filePath = expand('%:p')
  let l:line = line('.')
  exe "normal! \<c-W>w"
  exe "normal! o" . l:filePath . ":" . l:line  . " " . l:note . "\<Esc>"
  exe "normal! \<c-W>w"
  echo l:filePath . ":" . l:line
endfunction

command! -nargs=1 Note :call NoteCurrentFileAndLine(<q-args>)

let b:mappingsSet = 0
"unmap <buffer> j
"unmap <buffer> k
nnoremap <leader><CR> :call <SID>toggleMappings()<CR>

