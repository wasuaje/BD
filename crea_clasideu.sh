#apagar stonish y quorum de nodos no hace falta
crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore

#IP Real es .50 OJO
#Ips de cluster .39
crm configure primitive Ip39Clasideu ocf:heartbeat:IPaddr2 params ip="204.228.236.39" cidr_netmask="24" nic="eth0" op monitor interval="30s"

#listener de oracle para la instancia respectiva
crm configure primitive ClasideuListener ocf:heartbeat:oralsnr params sid=clasideu user="oracle" \
  listener="LISTENER_CLASIDEU" home=/opt/app/oracle/product/11.2.0/dbhome_1  \
  op monitor interval="30s" timeout=30s  op start timeout="120s" op stop timeout="120s"
  
#instancia de BBDD Oracle
crm configure primitive ClasideuInstance ocf:heartbeat:oracle params sid=clasideu user="oracle" \
     home=/opt/app/oracle/product/11.2.0/dbhome_1 op monitor interval=120s timeout=30s \
     op  start timeout="120s" op stop timeout="120s"

#Grupo: definicion y componentes
crm configure group ClasideuGroup Ip39Clasideu ClasideuListener ClasideuInstance

#Orden primero ip luego listener luego instancia
crm configure order OrderClasideuGroup inf: Ip39Clasideu ClasideuListener:start ClasideuInstance:start

#Configuro servicios que deben andar juntos siempre
crm configure colocation ColoClasideuGroup inf: Ip39Clasideu ClasideuListener ClasideuInstance

#Asigno un nodo predeterminado
crm configure location LocationClasideuGroup ClasideuGroup 60: manduca-db04
