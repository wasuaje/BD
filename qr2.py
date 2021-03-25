#!/usr/bin/python

import subprocess
ruta='/opt/app/oracle/product/11.2.0/dbhome_1/bin/'

connectString = 'hr/eluniversal@prueba'
#sqlCommand='select sysdate from dual;'
#sqlCommand='select * from COUNTRIES;'

from subprocess import Popen, PIPE
#function that takes the sqlCommand and connectString and retuns the output and #error string (if any)

def runSqlQuery(sqlCommand, connectString):
  session = Popen([ruta+'sqlplus', '-S', connectString], stdin=PIPE, stdout=PIPE, stderr=PIPE)
  session.stdin.write(sqlCommand)
  return session.communicate()

txt="""
SET HEADING ON  embedded on;
SET LINESIZE 150;
SET PAGESIZE 0;
SET TRIMSPOOL ON;
SET TIMING ON;
--SPOOL /root/mydata.dat
select * from hr.locations where rownum <= 1000000;
--SPOOL OFF
"""
#select count(*) from hr.locations;
#select * from hr.locations where rownum <= 100000;

txt2=""
if __name__ == "__main__":
   a=runSqlQuery(txt,connectString)
#   print a[0]

   #a=runSqlQuery("commit",connectString)
#  print a
