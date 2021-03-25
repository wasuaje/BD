#apagar stonish y quorum de nodos no hace falta
#crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore

#IP Real es .50 OJO
#Ips de cluster .38
crm configure primitive Ip50Content ocf:heartbeat:IPaddr2 params ip="204.228.236.50" cidr_netmask="24" nic="eth0" op monitor interval="30s"

#listener de oracle para la instancia respectiva
crm configure primitive ContentListener ocf:heartbeat:oralsnr params sid=content user="oracle" \
  listener="LISTENER_CONTENT" home=/opt/app/oracle/product/11.2.0/dbhome_1  \
  op monitor interval="30s" timeout=30s  op start timeout="120s" op stop timeout="120s"
  
#instancia de BBDD Oracle
crm configure primitive ContentInstance ocf:heartbeat:oracle params sid=content user="oracle" \
     home=/opt/app/oracle/product/11.2.0/dbhome_1 op monitor interval=120s timeout=30s \
     op  start timeout="120s" op stop timeout="120s"

#Grupo: definicion y componentes
crm configure group ContentGroup Ip50Content ContentListener ContentInstance

#Orden primero ip luego listener luego instancia
crm configure order OrderContentGroup inf: Ip50Content ContentListener:start ContentInstance:start

#Configuro servicios que deben andar juntos siempre
crm configure colocation ColoContentGroup inf: Ip50Content ContentListener ContentInstance

#Asigno un nodo predeterminado
crm configure location LocationContentGroup ContentGroup 55: manduca-db03




