if exists("loaded_related")
finish
endif
let loaded_related = 1
function! s:HR(arg1)
python <<EOF
import vim
import requests
import json

var1 = vim.eval("a:arg1")
vim.command("let a:current_filepath = expand('%:p')")
var2 = vim.eval("a:current_filepath")
print "params was" , var2, var1

vim.command("let a:current_filetype = &filetype")
var3 = vim.eval("a:current_filetype")
print var3

RUN_URL = 'http://api.hackerrank.com/checker/submission.json'
CLIENT_SECRET = 'hackerrank|7650-29|9efca3343c625bc8758aff2ed317a6c65e271019'
source = open(var2,"r").read()

languages ={"c":1,"cpp":2,"java":3,"csharp":9,"php":7,"ruby":8,"python":5,"perl":6,"haskell":12,"clojure":13,"scala":15,"bash":14,"mysql":10,"oracle":11,"erlang":16,"clisp":17,"lua":18,"go":21}
language_number = str(languages[var3])

tst = []
tstfile = open(var1,"r").readlines()
templine=""
delimiter = "---"
for line in tstfile:
	line = line[0:len(line)-1]
	if line!=delimiter:
		templine = templine + line
		templine = templine + "\n"
	else:
		tst.append(templine)
		templine = ""

tst.append(templine)

for i in range(0,len(tst)):
	tst[i] = tst[i][0:len(tst[i])-1]
print tst
x = json.dumps(tst)
data = {
    'source': source,
    'lang':   language_number,
    'testcases': x,
    'api_key': 	CLIENT_SECRET
}

r = requests.post(RUN_URL, data=data)
inp = json.loads(r.text)

errors = inp['result']['stderr']

flag = 0
for err in errors:
	if err:
		flag = 1

if flag == 1:
	print "Your code has some Bugs.Following are the errors..fix them..:-)"
	for err in errors:
		print err
else:
	print "Great!!!Your code has been successfully compiled and here's the ouput..:-)"
	for i in range(0,len(tst)):
		x = inp['result']['stdout'][i]
		x = x[0:len(x)-1]
		print x

EOF
endfunction
command! -nargs=1 Hr call s:HR(<f-args>)