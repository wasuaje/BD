#apagar stonish no hace falta
crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore

#Ips de cluster para prueba
crm configure primitive ClusterIP38 ocf:heartbeat:IPaddr2 params ip="204.228.236.38" cidr_netmask="24" nic="eth0" op monitor interval="30s"
#crm configure primitive ClusterIP39 ocf:heartbeat:IPaddr2 params ip="204.228.236.39" cidr_netmask="24" nic="eth0" op monitor interval="30s"

#listener
crm configure primitive OraclepruebaLstr ocf:heartbeat:oralsnr params sid="prueba" user="oracle" \
  listener="LISTENER_PRUEBA" home=/opt/app/oracle/product/11.2.0/dbhome_1  \
  op monitor interval="30s" timeout=30s  op start timeout="120s" op stop timeout="120s"
  

#instancia
crm configure primitive OraclePrueba ocf:heartbeat:oracle params sid=prueba user="oracle" \
     home=/opt/app/oracle/product/11.2.0/dbhome_1 op monitor interval=120s timeout=30s \
     op  start timeout="120s" op stop timeout="120s"


#Grupo oraprueba2
crm configure group ORAPRUEBA-GROUP ClusterIP38 OraclepruebaLstr OraclePrueba
#crm configure group ORAPRUEBA-GROUP ClusterIP38 OraclepruebaLstr

#Orden primero ip luego listener
crm configure order IP-Lstr-Db inf: ClusterIP38 OraclepruebaLstr:start OraclePrueba:start
#crm configure order IP-Lstr-Db inf: ClusterIP38 OraclepruebaLstr:start


#lo que va junto
crm configure colocation IP-Lstr-OraclePrueba inf: ClusterIP38 OraclepruebaLstr OraclePrueba
#crm configure colocation IP-Lstr-OraclePrueba inf: ClusterIP38 OraclepruebaLstr


#Nodo predeterminado
crm configure location ORAPRUEBA-GROUP-prefer-manduca-db03 ORAPRUEBA-GROUP 50: manduca-db03

#WARNING: OraclepruebaLstr: default timeout 20s for start is smaller than the advised 120
#WARNING: OraclepruebaLstr: default timeout 20s for stop is smaller than the advised 120
#WARNING: OraclePrueba: default timeout 20s for start is smaller than the advised 120
#WARNING: OraclePrueba: default timeout 20s for stop is smaller than the advised 120
#WARNING: OraclePrueba: default timeout 20s for monitor is smaller than the advised 30


