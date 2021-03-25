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

if __name__ == "__main__":

  txt=""
  for h in range(1,1200000):
    txt=""
    for i in range(1,4000):
      txt+="INSERT INTO hr.locations (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE, CITY,STATE_PROVINCE,COUNTRY_ID) VALUES  (hr.LOCATIONS_SEQ.nextval,'prueba','prueba','Roma','prueba','IT');\n"

    txt+="COMMIT;"
    a=runSqlQuery(txt,connectString)
    print a


  a=runSqlQuery("select count(*) from  hr.locations;",connectString)
  print a
