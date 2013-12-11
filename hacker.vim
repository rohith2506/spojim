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

RUN_URL = 'http://api.hackerrank.com/checker/submission.json'
CLIENT_SECRET = 'hackerrank|7650-29|9efca3343c625bc8758aff2ed317a6c65e271019'
source = open(var1,"r").read()
language_number = '5'
tst = []
tstfile = open(var2,"r").readlines()
for line in tstfile:
	tst.append(line)
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
