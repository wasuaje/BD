#apagar stonish y quorum de nodos no hace falta
crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore

#IP Real es .50 OJO
#Ips de cluster .32
crm configure primitive Ip32Empleos ocf:heartbeat:IPaddr2 params ip="204.228.236.32" cidr_netmask="24" nic="eth0" op monitor interval="30s"

#listener de oracle para la instancia respectiva
crm configure primitive EmpleosListener ocf:heartbeat:oralsnr params sid=cvf3 user="oracle" \
  listener="LISTENER_CVF3" home=/opt/app/oracle/product/11.2.0/dbhome_1  \
  op monitor interval="30s" timeout=30s  op start timeout="120s" op stop timeout="120s"
  
#instancia de BBDD Oracle
crm configure primitive EmpleosInstance ocf:heartbeat:oracle params sid=cvf3 user="oracle" \
     home=/opt/app/oracle/product/11.2.0/dbhome_1 op monitor interval=120s timeout=30s \
     op  start timeout="120s" op stop timeout="120s"

#Grupo: definicion y componentes
crm configure group EmpleosGroup Ip32Empleos EmpleosListener EmpleosInstance

#Orden primero ip luego listener luego instancia
crm configure order OrderEmpleosGroup inf: Ip32Empleos EmpleosListener:start EmpleosInstance:start

#Configuro servicios que deben andar juntos siempre
crm configure colocation ColoEmpleosGroup inf: Ip32Empleos EmpleosListener EmpleosInstance

#Asigno un nodo predeterminado
crm configure location LocationEmpleosGroup EmpleosGroup 65: manduca-db04




