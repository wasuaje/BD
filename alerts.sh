#!/bin/bash
# Para buscar por error de cluster y
# efectuar una alerta temprana

nodo=$(uname -n)
lineas=0
stonit=0
fecha=$(date +"%b %d")
#fecha="jul 22"
errores=$(cat /var/log/messages| grep -i "$fecha"|grep error | wc -l)
stonit=$(cat /var/log/messages| grep -i "$fecha"| grep stoni| wc -l)

cat /var/log/messages| grep -i "$fecha"|grep error > /tmp/alerta.txt
echo "**************************************" >> /tmp/alerta.txt
cat /var/log/messages| grep -i "$fecha"| grep stoni >> /tmp/alerta.txt

#echo $lineas
#echo $stonit

function enviar_mail {
               /bin/mail -s "ERRORES EN CLUSTER - "$nodo  wasuaje@eluniversal.com < /tmp/alerta.txt
           }

if [ $lineas -gt 0 -o $stonit -gt 0 ];then
 enviar_mail
fi


