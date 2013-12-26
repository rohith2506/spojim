# Required headers for mechanize in python
import mechanize
from mechanize import Browser
import cookielib
import time
from bs4 import BeautifulSoup
base_url = "http://www.spoj.com"
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

# MAIN CODE STARTS HERE
''' Cases i have to handle:
        1) accepted
        2) wrong answer
        3) time limit exceeded
        4) compilation error (specifing the message also)
        5) runtime error
'''


r = br.open("http://www.spoj.com/submit/ABCDEF/")
for f in br.forms():
    print "gekko"
    print f
br.select_form(nr=0)
br.form['login_user']='rohspeed'
br.form['password'] = '8885376049'
br.submit()

br.select_form(nr=0)
src = open("/home/infinity/Algo/spoj/abcdef.cpp","r").read()
#print src 
br.form['file'] = src
lang = 41
lang = str(lang)
lst = []
lst.append(lang)
br.form['lang'] = lst
br.form['problemcode'] = 'ABCDEF'
br.submit()

errors = ["accepted","time limit exceeded","wrong answer","compilation error","runtime error"]

while True:
        url = "http://www.spoj.com/status/ABCDEF,rohspeed/"
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
                        print res
                        flag2 = 1
                elif res == "wrong answer":
                        print res
                        flag2 = 1
                elif res == "time limit exceeded":
                        print res
                        flag2 = 1
                elif res == "runtime error":
                        temp = lst[0].split()
                        print temp
                        temp_str = temp[2] +" " + temp[3]
                        temp_str = temp_str[1:len(temp_str)-1]
                        print temp_str
                        soup2 = BeautifulSoup(temp_str)
                        print soup2
                        x = soup2.a.get_text()
                        print x
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
                        print res
                        print "Following errors are:"
                        print text
                        flag2 = 1
                else:
                        pass
        else:
                print lst[0]
                time.sleep(1)

        if flag2 == 1:
                break
