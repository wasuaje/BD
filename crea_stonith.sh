#crm configure primitive impi-fencing stonith:fence_ipmilan \
# params pcmk_host_list="manduca-db03 manduca-db04" ipaddr=204.228.236.6 \
 
# login=manduca passwd="D3c4r#m6o!A"  op monitor interval="60s"

#crm configure property stonith-enabled=true

crm configure primitive stonith_sistema stonith:fence_pcmk \
       params pcmk_host_list="manduca-db03 manduca-db04"

crm configure property stonith-enabled=true
crm configure property stonith-action=poweroff
crm configure rsc_defaults resource-stickiness=100

