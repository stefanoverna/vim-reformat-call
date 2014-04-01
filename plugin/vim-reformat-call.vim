" reformat call
function! ReformatCall()
  let braces = { '{': '}', '(': ')', '[': ']' }

  " get current line
  let line = getline('.')

  " accumulators
  let result = ""
  let len = strlen(line)
  let i = 0
  let depth = 0
  let brace = 0

  " parser
  while i < len
    let c = strpart(line, i, 1)
    let i += 1

    if depth == 0 && has_key(braces, c)
      let depth += 1
      let brace = c
      let result .= c . "\n"
      continue
    elseif depth > 0 && c == brace
      let depth += 1
    elseif depth == 1 && c == ","
      let result .= c . "\n"
      continue
    elseif depth == 1 && c == braces[brace]
      let result .= "\n" . c
      let depth -= 1
      continue
    elseif depth > 0 && c == braces[brace]
      let depth -= 1
    end

    let result .= c
  endwhile

  " remove trailing whitespace
  let result = substitute(result, " \*\n", "\n", "g")

  " delete current line
  normal dd
  " replace with result
  put! =result
  " select the result
  normal `[v`]
  " reindent selection
  normal =
endfunction
:command! ReformatCall :call ReformatCall()

