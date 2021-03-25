#apagar stonish y quorum de nodos no hace falta
crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore

#Ips de cluster .46
crm configure primitive Ip46Users ocf:heartbeat:IPaddr2 params ip="204.228.236.46" cidr_netmask="24" nic="eth0" op monitor interval="30s"

#listener de oracle para la instancia respectiva
crm configure primitive UserListener ocf:heartbeat:oralsnr params sid="users" user="oracle" \
  listener="LISTENER_USERS" home=/opt/app/oracle/product/11.2.0/dbhome_1  \
  op monitor interval="30s" timeout=30s  op start timeout="120s" op stop timeout="120s"
  
#instancia de BBDD Oracle
crm configure primitive UserInstance ocf:heartbeat:oracle params sid=users user="oracle" \
     home=/opt/app/oracle/product/11.2.0/dbhome_1 op monitor interval=120s timeout=30s \
     op  start timeout="120s" op stop timeout="120s"

#Grupo: definicion y componentes
crm configure group UsersGroup Ip46Users UserListener UserInstance

#Orden primero ip luego listener luego instancia
crm configure order OrderUsersGroup inf: Ip46Users UserListener
crm configure order OrderUsersGroup2 inf:  UserListener UserInstance:start

#Configuro servicios que deben andar juntos siempre
crm configure colocation ColoUsersGroup inf: Ip46Users UserListener UserInstance

#Asigno un nodo predeterminado
crm configure location LocationUsersGroup UsersGroup 50: manduca-db04




