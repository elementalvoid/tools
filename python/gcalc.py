#!/usr/bin/python

# Created 4/8/09 by Daedalus
# http://fublag.wordpress.com
# actaeus@gmail.com

import urllib, httplib, sys, readline

def main(argv=None):
    while 1:
        if argv:
            q = argv
        else:
            try:
                q = raw_input("> ")
            except:
                print
                sys.exit()
        if q in ('quit', 'exit'): sys.exit()
        query=urllib.urlencode({'q':q})

        start='<h2 class=r style="font-size:138%"><b>'
        end='</b>'

        google=httplib.HTTPConnection("www.google.com")
        google.request("GET","/search?num=0&"+query)
        search=google.getresponse()
        data=search.read()

        if data.find(start)==-1: print "Google Calculator results not found."
        else:
            begin=data.index(start)
            result=data[begin+len(start):begin+data[begin:].index(end)]
            result = result.replace("<font size=-2> </font>",",").replace(" &#215; 10<sup>","E").replace("</sup>","").replace("\xa0",",")
            print result
        if argv: break
if __name__ == "__main__":
    try: main(sys.argv[1])
    except: main()
