" File:    ldap.vim
" Version: 0.91
" Author:  David Morris
" Purpose: Active Directory / LDAP connection using Python
"
" NOTE:    This plugin requires VIM to be compiled with the Python
"          interpreter!

if exists("ActiveDirectoryLDAP")
    finish
endif
let ActiveDirectoryLDAP = 1


function! LDAPLookup()
python << EOF
import vim
import ldap

################################################################################
# CONFIGURATION
#
# DEFAULT_USER
# Default username to use when logging into the LDAP server.  Set to an
# empty string if no authentication is required.  Note that this is NOT
# your Windows login username!  The easiest way to find out what this
# string should be is to talk to your IT department.  If this is not
# possible for some reason, install Python on a Windows computer along with
# the win32com library (http://www.python.org/windows).  Then get the
# 'active_directory' library from
# (http://tgolden.sc.sabren.com/python/ad_cookbook.html).  The
# username you should use can be found by using the python command
# 'python active_directory.find_user("my_username")' where "my_username" is
# your windows logon username.  From that string, drop off the leading
# "LDAP://"
DEFAULT_USER    =""

# The default base is where the search for users will start from.  I
# recommend including all DC fields from your user string above.
DEFAULT_BASE    ="dc=intersec,dc=com"

# This needs to be the IP address or computer name of the Active Directory
# controller (e.g. dc1.my.company.com)
DEFAULT_SERVER  ="ldap://papyrus.corp"

# This is the password used to login, if needed.  Set to an empty string if
# no password is used.
DEFAULT_PASSWORD=""

################################################################################

class ActiveDirectoryLDAP(object):
    def Login(self, username=DEFAULT_USER, password=DEFAULT_PASSWORD):
        if username:
            resID = self.__ld.simple_bind(username, password)
            rt,rd=self.__ld.result(resID, 0)
            print rt,rd
        else:
            return 100,[]
        #end if
    #end def Login

    def Search(self, username, base=DEFAULT_BASE):
        if not username:
            return 0
        resID = self.__ld.search(base, ldap.SCOPE_SUBTREE, "displayName=%s*" % username)
        retVal = None
        rt,rd=self.__ld.result(resID, 0)
        if rd != []:
            retVal = '%s <%s>' % (rd[0][1]['displayName'][0], rd[0][1]['mail'][0])
        else: retVal = username
        #end if

        return retVal
    #end def Search

    def __init__(self, server=DEFAULT_SERVER):
        super(ActiveDirectoryLDAP, self).__init__()
        self.__server = server
        self.__ld = ldap.initialize(server)
    #end def __init__
#end class ActiveDirectoryLDAP

ecol  = vim.current.window.cursor[1]+1
line = vim.current.line[:ecol]

scol = line.rfind(' ') + 1

line = line[scol:ecol+1]

ado = ActiveDirectoryLDAP()
ado.Login()
res = ado.Search(line)

if res:
    newline = vim.current.line[:scol]
    newline += res
    newline += vim.current.line[ecol+1:]

    row,col = vim.current.window.cursor
    vim.current.line = newline
    vim.current.window.cursor = row,scol+len(res)
#end if

EOF
endfunction

imap <C-F> <ESC>:call LDAPLookup()<C-M>a

