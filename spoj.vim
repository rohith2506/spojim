if exists("loaded_related")
finish
endif
let loaded_related = 1
function! s:spj(arg1)

python <<EOF
import vim
import requests
import json
import mechanize
from mechanize import Browser
import cookielib
import time
from bs4 import BeautifulSoup
base_url = "http://www.spoj.com"
submit_key = "/submit/"
status_key = "/status/"
NZEC = "(NZEC)"
errors = ["accepted","time limit exceeded","wrong answer","compilation error","runtime error"]
languages ={"c":11,"cpp":41,"java":10,"cs":27,"php":29,"ruby":17,
			"python":4,"perl":3,"haskell":21,"clojure":111,"scala":39,"bash":28,
			"erlang":36,"go":114}
user_name = 'rohspeed'
passwd    = '8885376049'
# Browser
br = mechanize.Browser()

# Cookie Jar
cj = cookielib.LWPCookieJar()
br.set_cookiejar(cj)

# Browser options
br.set_handle_equiv(True)
#br.set_handle_gzip(True)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)

# Follows refresh 0 but not hangs on refresh > 0
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

# Want debugging messages?
#br.set_debug_http(True)
#br.set_debug_redirects(True)
#br.set_debug_responses(True)

# User-Agent (this is cheating, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]
# End Headers

var1 = vim.eval("a:arg1")
vim.command("let a:current_filepath = expand('%:p')")
var2 = vim.eval("a:current_filepath")
print "params was" , var2, var1

vim.command("let a:current_filetype = &filetype")
var3 = vim.eval("a:current_filetype")
print var3


# MAIN CODE STARTS HERE
url = base_url + submit_key + var1
# print url
r = br.open(url)

'''
for f in br.forms():
	print "gekko"
	print f
'''

br.select_form(nr=0)
br.form['login_user'] = user_name
br.form['password']   = passwd
br.submit()

br.select_form(nr=0)
src = open(var2,"r").read()
# print src 
br.form['file'] = src
lst = []
lst.append(str(languages[var3]))
br.form['lang'] = lst
br.form['problemcode'] = var1
br.submit()

while True:
	url = base_url + status_key + var1 + "," + user_name
#	print url
	page = br.open(url)

	html = page.read()
	soup = BeautifulSoup(html)

	labels = soup.findAll('table')[0].findAll('td', attrs={'class' : 'statusres'})
	temp_str = labels[0].renderContents().strip()
	lst = temp_str.split("\n")
	lst = lst[0:3]
	res = ""
	flag = 0
	flag2 = 0

	for i in range(0,len(lst)):
		x = lst[i].strip('.')
		x = lst[i].strip('\t')
		for err in errors:
			if err in x:
				res = err
				flag = 1
				break
		if flag == 1:
			break

	if flag == 1:
		if res == "accepted":
			print "HOLA!!!!!!!!!!! YOUR PROBLEM GOT ACCEPTED...:-)"
			flag2 = 1
		elif res == "wrong answer":
			print "OOPS!!!!WRONG ANSWER"
			flag2 = 1
		elif res == "time limit exceeded":
			print "OOPS!!!!TIME LIMIT CROSSED"
			flag2 = 1
		elif res == "runtime error":
			temp = lst[0].split()
			if temp[2] == NZEC:
				print lst[0]
			else:
	#			print temp
				temp_str = temp[2] +" " + temp[3]
				temp_str = temp_str[1:len(temp_str)-1]
	#			print temp_str
				soup2 = BeautifulSoup(temp_str)
	#			print soup2
				x = soup2.a.get_text()
	#			print x
				print temp[0] + " "+ temp[1] + "(" + x + ")"
			flag2 = 1
		elif res == "compilation error":
			# its different here
			# print "iam here"
			soup2 = BeautifulSoup(lst[0])
			val = soup2.a['href']
			url1 = base_url + val
			# print url1
			page1 = br.open(url1)
			html1 = page1.read()
			soup1 = BeautifulSoup(html1)
			text = soup1.small.get_text()
			print "OOPS!!!!COMPILATION ERRORS"
			print "Following Errors are:"
			print "################"
			print text
			print "################"
			flag2 = 1
		else:
			pass
	else:
		print lst[0]
		time.sleep(5)

	if flag2 == 1:
		break

EOF
endfunction
command! -nargs=1 Spoj call s:spj(<f-args>)

