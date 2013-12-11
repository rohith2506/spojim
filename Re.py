import requests
import json

RUN_URL = 'http://api.hackerrank.com/checker/submission.json'
CLIENT_SECRET = 'hackerrank|7650-29|9efca3343c625bc8758aff2ed317a6c65e271019'
source = open("source.py","r").read()
language_number = '5'
tst = []
tstfile = open("test.py","r").readlines()
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

