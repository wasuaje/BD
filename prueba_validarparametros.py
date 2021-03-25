#!/usr/bin/python
import cx_Oracle
#conn_str='hr/eluniversal@prueba'
#conn_str = 'hr/eluniversal@204.228.236.56:1521/prueba'
#conn_str = 'nagios/oradbmon@content'
conn_str = 'deuprocesos/Br0ntoS4ur!O@clasideu'
db_conn = cx_Oracle.connect(conn_str)
cursor = db_conn.cursor()
#cursor.execute('SELECT * FROM locations where rownum<51')
#registros = cursor.fetchall()
#print len(registros)
#for r in registros:
#  print str(r)

txt = "SELECT u.nombre || ' ' || u.apellido nombre, co.telefono_1, co.telefono_2,co.telefono_3, cl.id_clasificado, cl.cod_rubro, cl.estatus_pauta, cl.paso, cpp.estatus,  gp.producto, gp.descripcion FROM clasificado cl INNER JOIN clasificado_producto_pago cpp ON cl.id_clasificado=cpp.id_clasificado AND cpp.estatus NOT  IN ('EXPIRADO') AND cpp.cod_canal_ingreso ='ONLINE' AND trunc(cpp.fecha_creacion) = trunc(sysdate-1) LEFT JOIN pago p ON cpp.id_clasificado_producto_pago=p.id_clasificado_producto_pago INNER JOIN usuario_temp u ON cl.id_usuario_dueno=u.id_usuario LEFT JOIN contacto co ON cl.id_clasificado=co.id_clasificado LEFT JOIN empresa e ON u.id_empresa=e.id_empresa INNER JOIN producto pr ON cpp.id_producto=pr.id_producto INNER JOIN grupo_producto gp ON gp.id_grupo_producto=pr.id_grupo_producto INNER JOIN clasificado_mediopublicacion cm ON cl.id_clasificado=cm.id_clasificado AND cm.cod_medio_publicacion='INTERNET' INNER JOIN categoria cat ON cm.id_categoria=cat.id_categoria WHERE cl.id_clasificado NOT IN ( SELECT cl1.id_clasificado  FROM clasificado cl1 INNER JOIN clasificado_producto_pago cpp1 ON cl1.id_clasificado=cpp1.id_clasificado AND cpp1.estatus IN('ACTIVO','ANULADO_NEGOCIO','ELIMINADO','POR_FACTURAR') GROUP BY cl1.id_clasificado) ORDER BY cpp.fecha_creacion desc, cl.id_clasificado" 

for i in range (1,50):
	cursor.execute(txt)
	db_conn.commit()
	#cursor.execute('SELECT count(*) FROM locations ')
	registros = cursor.fetchall()
	print len(registros)
#for r in registros:
#  print "devuelve:", str(r)

