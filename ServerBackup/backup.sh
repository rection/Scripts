#!/bin/bash

## postgresql backups, hugo backup, redmine backup, jenkins backup, vpn conf and keys backup, samba server backup(srv), postfix, dovecot configuration files backups, Maildir's backups.

USERS="safa redmine root"


if [[ $EUDI -ne 0 ]]
then
    echo "This script must be run as root"
    exit 1
fi

if [[ -f "/root/backups" ]]
then
    cd /root/backups
else
    mkdir /root/backups && cd /root/backups/
fi


## Maildir, postfix and dovecot
timeslot=`date +%d-%m-%Y`
echo "Mail Backup Process Start..."
for user in $USERS
do
    if [[ $user -eq "root" ]]
    then
	if [[ ! -f "/root/backups/MailExchange/$user" ]]
	then
	    mkdir -p /root/backups/MailExchange/root > /dev/null
	fi
	rsync -avz /root/Maildir /root/backups/MailExchange/root/
    else
	if [[ ! -f "/root/backups/MailExchange/$user" ]]
	then
	    mkdir -p /root/backups/MailExchange/$user > /dev/null
	fi
	rysnc -avz /home/$user/Maildir/ /root/backups/MailExchange/$user
    fi
done
if [[ ! -f /root/backups/MailExchange/conf || ! -f  /root/backups/MailExchange/dovecot ]]
then
    mkdir -p /root/backups/MailExchange/conf /root/backups/MailExchange/dovecot > /dev/null
fi
cd /etc/postfix && rsync -avz main.cf master.cf relaydomains privatekey.key secure.crt /root/backups/MailExchange/conf/
cd ../dovecot/ && rsync -avz conf.d dovecot.conf private /root/backups/MailExchange/dovecot/
tar cfz /root/backups/MailExchange_$timeslot.tar.gz /root/backups/MailExchange/
rm -rf /root/backups/MailExchange/
echo "Mail Backup Process Finished..."


## Redmine
echo "Redmine Backup Process Start..."
backup_dir="/root/backups/redmine"
timeslot=`date +%d-%m-%Y`
if [[ ! -f /root/backups/redmine ]]
then
    mkdir /root/backups/redmine/ > /dev/null
fi
tar cfz /root/backups/redmine/redminehome_$timeslot.tar.gz /home/redmine/redmine-4.0.5
su - redmine -c "vacuumdb redmine"
su - redmine -c "pg_dump redmine | gzip > /root/backups/redmine/redmine_database_$timeslot.gz"
echo "Redmine Backup Finished..."

## Hugo
echo "Hugo Backups Process Start..."
timeslot=`date +%d-%m-%Y`
hugo_dir="/www/data/safabayar.tech/"
backup_dir="/root/backups/blog"
nginx_dir="$backup_dir/nginx"
if [[ ! -f $backup_dir ]]
then
    mkdir $backup_dir $nginx_dir > /dev/null
fi
rsync -avz $hugo_dir $backup_dir/hugo_home/
rsync -avz /etc/nginx/conf.d /etc/nginx/nginx.conf $nginx_dir/
tar cfz $backup_dir/hugo_home_$timeslot.tar.gz $backup_dir/hugo_home/
rm -rf $backup_dir/hugo_home/

echo "Hugo Backups Process Finished..."

## OpenVPN
echo "Openvpn Backups Process Started..."
timeslot=`date +%d-%m-%Y`
openvpn_dir="/etc/openvpn/"
backup_dir="/root/backups/openvpn"
rsync -avz $openvpn_dir $backup_dir/
tar czf $backup_dir/openvpn_$timeslot.tar.gz $backup_dir
echo "Openvpn Backups Process Finished..."

## Log Files
echo "Log Backups Process Started..."
timeslot=`date +%d-%m-%Y`
backup_dir="/root/backups"
if [[ ! -f $backup_dir/logs ]]
then
    mkdir $backup_dir/logs > /dev/null
fi
# rsync -avz /var/log/{audit,clamav,dovecot.log,firewalld,jenkins,messages,maillog,openvpn,nginx,php-fpm,samba,secure,spamassassin,sssd} $backup_dir/logs
rsync -avz /var/log/ $backup_dir/logs
tar czf $backup_dir/logs.tar.gz $backup_dir/logs/
echo "Log Backups Process Finished"

## Stamps
backup_dir="/root/backups"
timeslot=`date +%d-%m-%Y`
tar cvfz /root/Backup_$timeslot.tar.gz $backup_dir
rm -rf $backup_dir
