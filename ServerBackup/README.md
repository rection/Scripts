Usage Of The Script

You need to be root user. The script check for you.

The script takes backups of Redmine, Jenkins, PostgreSQL, OpenVPN, Static Web Site, Dovecot, ClamAV, Postfix, Log files.

```
chmod +x backup.sh
./backup.sh
```

Jenkins, execute shell codes:

```
chmod +x backup.sh
sudo su -c 'bash /var/lib/jenkins/workspace/Backup/backup.sh'
```
