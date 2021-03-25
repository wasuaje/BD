#!/usr/bin/python
import cx_Oracle
#conn_str='hr/eluniversal@prueba'
#conn_str = 'hr/eluniversal@204.228.236.56:1521/prueba'
conn_str = 'nagios/oradbmon@content'
db_conn = cx_Oracle.connect(conn_str)
cursor = db_conn.cursor()
#cursor.execute('SELECT * FROM locations where rownum<51')
#registros = cursor.fetchall()
#print len(registros)
#for r in registros:
#  print str(r)


txt="select decode(status,'OPEN',0,1) estatus from v$instance"

cursor.execute(txt)
db_conn.commit()

#cursor.execute('SELECT count(*) FROM locations ')
registros = cursor.fetchall()
print len(registros)
for r in registros:
  print "devuelve:", str(r)

