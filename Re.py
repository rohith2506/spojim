import requests
import json

RUN_URL = 'http://api.hackerrank.com/checker/submission.json'
CLIENT_SECRET = 'hackerrank|7650-29|9efca3343c625bc8758aff2ed317a6c65e271019'
source = open("source3.cpp","r").read()
language_number = '2'
tst = []
tstfile = open("test3.txt","r").readlines()
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
print "Your test input:"
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