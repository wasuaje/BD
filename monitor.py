#!/usr/bin/python
import cx_Oracle
import sys

#Los posibles valores de salida
EXITOK=0
EXITWA=1
EXITCR=2
EXITUK=-1


BBDD = sys.argv[1]
SERV = sys.argv[2]
if  SERV not in "conexiones status":
	print "Parametro desconocido %s" % sys.argv[2]
	sys.exit(EXITUK)


qry1="select decode(status,'OPEN',0,2) estatus from v$instance"
qry2="""SELECT (CASE 
    WHEN round((CONEXIONES*100)/VALUE,2)< 80 THEN '0' 
    WHEN round((CONEXIONES*100)/VALUE,2)>= 80 AND round((CONEXIONES*100)/VALUE,2) <90 THEN '1' 
    WHEN round((CONEXIONES*100)/VALUE,2)>=90 THEN '2' 
    END) ESTATUS  FROM v$system_parameter,(SELECT COUNT(*) "CONEXIONES" FROM v$session) 
    where name ='sessions' """

#data 
data={'status':{'qry':qry1,0:"0 - OK",1:"1 - Critical BD no abierta  "},
      'conexiones':{'qry':qry2,0:"OK: -80 Conexiones",1:"Warning: 80-90 Conexiones",2:"Critical: +90 Conexiones"}
     }

servicios={'content':'nagios/oradbmon@content',
          'clasideu':'nagios/oradbmon@clasideu',
          'cvf3':'nagios/oradbmon@cvf3',
          'users':'nagios/oradbmon@users'
          }

conn_str=servicios[BBDD]
db_conn = cx_Oracle.connect(conn_str)
cursor = db_conn.cursor()
cursor.execute(data[SERV]['qry'])

#para inserts
#db_conn.commit()

registros = cursor.fetchall()
#print len(registros)
#print registros 
#for r in registros:
#  print "devuelve:", str(r)

retorno=int(registros[0][0])
print data[SERV][retorno]
sys.exit(retorno)

