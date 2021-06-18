#!/bin/sh

#!/bin/sh

LOGIN="<PUT NAME>"
PASS="<PUT PASS>"

######### CREATE USERS
adduser -D "$LOGIN"
adduser -D smbuser
echo -e "$PASS\n$PASS" | smbpasswd -a -s $LOGIN
echo -e "$PASS\n$PASS" | smbpasswd -a -s smbuser
if [ $? -eq 0 ]
then
  echo "OK"
  addgroup smb
else
  echo "Error"
  exit 1
fi

######## CREATE DIRECTORIES FROM printers.conf
PRINTERS=$(sed -n -e 's/^.*\(<Printer \)//p' /etc/cups/printers.conf  | sed 's/.$//')

for NUMBERS in $PRINTERS; do
   su -m smbuser -c "mkdir /temporary/$NUMBERS"
done

# su -m smbuser -c "mkdir /temporary/$(sed -n -e 's/^.*\(<Printer \)//p' /etc/cups/printers.conf  | cut -c1-6)"


####### ADD PRINTERS TO CRONTAB
FILE='/etc/crontabs/root'

for NUMBERS in $PRINTERS; do
   LINE="* * * * *  /temporary/scripts/print.sh /temporary/ $NUMBERS > /dev/null 2>&1"
   grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
done


################ SMB BACKEND 4 CUPS
ln -s /usr/bin/smbspool /usr/lib/cups/backend/smb
mkdir /kopia_smb
/bin/chown -R smbuser:smb /kopia_smb

########### CHANGE FILES & DIRECTIORIES PERMISSIONS
mkdir -p /temporary/wydruki
/bin/chown -R smbuser:smb /temporary
find /temporary -type d ! -perm 775 -exec chmod 775 {} \;
find /temporary -type f ! -perm 0664 -exec chmod 0664 {} \;
/bin/chmod 777 /temporary/scripts/*

########## START DAEMONS
/usr/sbin/crond -b -l 8 -d 8
/usr/sbin/smbd -D
/usr/sbin/cupsd -f

