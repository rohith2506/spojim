if exists("loaded_related")
finish
endif
let loaded_related = 1
function! s:HR(arg1,arg2)
python <<EOF
import vim
import requests
import json

var1 = vim.eval("a:arg1")
var2 = vim.eval("a:arg2")
print "params was", var1, var2

vim.command("let a:current_filetype = &filetype")
var3 = vim.eval("a:current_filetype")
print var3

RUN_URL = 'http://api.hackerrank.com/checker/submission.json'
CLIENT_SECRET = 'hackerrank|7650-29|9efca3343c625bc8758aff2ed317a6c65e271019'
source = open(var1,"r").read()

languages ={"c":1,"cpp":2,"java":3,"csharp":9,"php":7,"ruby":8,"python":5,"perl":6,"haskell":12,"clojure":13,"scala":15,"bash":14,"mysql":10,"oracle":11,"erlang":16,"clisp":17,"lua":18,"go":21}
language_number = str(languages[var3])

tst = []
tstfile = open(var2,"r").readlines()
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
print inp['result']['stderr']
for i in range(0,len(tst)):
	print inp['result']['stdout'][i]

EOF
endfunction
command! -nargs=* Hr call s:HR(<f-args>)