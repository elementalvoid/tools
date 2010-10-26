#!/usr/bin/env python
import pycurl
import re
from StringIO import StringIO

class CurlSession():
    """Use persistent pycurl object with automatic cookie tracking"""
    cookieRegex = re.compile("Set-Cookie: (.*); path=/")

    def __init__(self, url = None, userpass = None):
        self.cookie = ""
        self.url = url
        self.userpass = userpass
        self.header = StringIO()
        self.data = StringIO()
        self.pc = pycurl.Curl()
        if self.userpass:
            self.pc.setopt(pycurl.USERPWD, self.userpass)
        if self.url:
            self.pc.setopt(pycurl.URL, self.url)
        self.pc.setopt(pycurl.WRITEFUNCTION, self.data.write)
        self.pc.setopt(pycurl.HEADERFUNCTION, self.header.write)

    def resetStringIO(self, toResest):
        """Empty out a StringIO object"""
        toResest.seek(0)
        toResest.truncate()

    def perform(self):
        """Perform the curl and gather the cookie if one exists."""
        self.pc.setopt(pycurl.COOKIE, self.cookie)
        self.resetStringIO(self.header)
        self.resetStringIO(self.data)
        self.pc.perform()
        if self.cookie == "" or self.cookie == None:
            try:
                cookies = CurlSession.cookieRegex.findall(self.header.getvalue())
                for c in cookies:
                    self.cookie = self.cookie + c + '; '
            except:
                pass

if __name__ == "__main__":
    """Test harness"""
    import curlsession
    url = 'http://www.denverpost.com'
    print 'Tesing on', url
    curler = curlsession.CurlSession(url)
    for i in range(3):
        print '  Run:', i + 1
        curler.perform()
        print '  ', curler.cookie
    url = 'http://www.yahoo.com'
    print 'Tesing on', url
    curler = curlsession.CurlSession(url)
    for i in range(3):
        print '  Run:', i + 1
        curler.perform()
        print '  ', curler.cookie
