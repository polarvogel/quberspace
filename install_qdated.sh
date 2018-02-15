#!/bin/bash

# qdated Installation im Uberspace
# Auskunft, 24.04.2013
# www.8300111.de

# Werte einlesen
echo "Wohin mit den Mails (z.B.  'uberspaceuser-info', ohne ' )?"
read to_adress

echo "Praefix fuer die temp. Mails (z.B. 'dated', ohne ' ):"
read prefix

echo "Domain fuer deine temporaeren Adressen (hinter dem @-Zeichen, also \"domain.de\" oder&nbsp;\"username.server.uberspace.de\"):"
read suffix

# Ordner im bin-Verzeichnis des Users anlegen
mkdir ~/bin/qdated
cd ~/bin/qdated

# qdated herunterladen
# original Link offline, wget http://www.palomine.net/qdated/qdated-0.53.tar.gz
wget http://web.archive.org/web/20130408040225/http://www.palomine.net/qdated/qdated-0.53.tar.gz
gunzip qdated-0.53.tar.gz
tar -xpf qdated-0.53.tar 
rm qdated-0.53.tar 
cd mail/qdated-0.53/

# qdated nach ~/bin/qdated installieren
package/install
mv ~/bin/qdated/mail/qdated/command/* ~/bin/qdated
rm -r ~/bin/qdated/mail

# qdated key erzeugen
~/bin/qdated/qdated-makekey

# .qmail Datei zum pruefen der eingehenden Mails erzeugen
echo "# Adresse darf maximal 7 Tage und 12 Stunden alt sein (60*60*24*7 + 60*60*12 = 648000 Sekunden)" > ~/.qmail-$prefix-default
echo "|~/bin/qdated/qdated-check 648000" >> ~/.qmail-$prefix-default
echo "$to_adress" >> ~/.qmail-$prefix-default

# erzeuge ein Script (in ~/bin/qdated/get_new_mail.sh, das von einem Cronjob aufgerufen werden kann und eine vollstaendige,
# aktuelle E-Mail Adresse in ~/html/current_mail schreibt

echo "#!/bin/bash" > ~/bin/qdated/get_new_mail.sh
echo "" >> ~/bin/qdated/get_new_mail.sh
echo "# schreibt bei Aufruf eine vollstaendige E-Mail Adresse mit aktuellem Zeitstempel" >> ~/bin/qdated/get_new_mail.sh
echo "# in ~/html/current_mail" >> ~/bin/qdated/get_new_mail.sh
echo "# www.8300111.de" >> ~/bin/qdated/get_new_mail.sh
echo "" >> ~/bin/qdated/get_new_mail.sh
echo "PREFIX=$prefix-" >> ~/bin/qdated/get_new_mail.sh
echo "SUFFIX=@$suffix" >> ~/bin/qdated/get_new_mail.sh
echo "TIMESTAMP=\`~/bin/qdated/qdated-now\`" >> ~/bin/qdated/get_new_mail.sh
echo "TOPATH=~/html/current_mail" >> ~/bin/qdated/get_new_mail.sh
echo "" >> ~/bin/qdated/get_new_mail.sh
echo "echo -n \$PREFIX\$TIMESTAMP\$SUFFIX > \$TOPATH"  >> ~/bin/qdated/get_new_mail.sh

chmod +x  ~/bin/qdated/get_new_mail.sh

echo ""
echo "--------"
echo ""
echo ""

echo "Fertig!"
echo "Details siehe Doku, 'http://www.palomine.net/qdated/'"
echo "Jetzt Conrjob einrichten!"
echo ""
echo ""
