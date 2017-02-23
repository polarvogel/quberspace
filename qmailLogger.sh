#!/bin/bash
#Log incoming E-Mails handeled by qmail
#8300111.de

echo "Incoming Mail from $SENDER to $RECIPIENT at `date`." >> ~/incomingQMails.txt
