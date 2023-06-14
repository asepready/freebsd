## Layanan Penjadwal Backup dengan Cron & NTP(Network Time Protocol)
```sh
apt-get install ntpdate

#konfig ntp
ntpdate id.pool.ntp.org

#buat file backup
mkdir ~/backup
```
### konfigurasi crontab untuk backup sysadmin
konfigurasi crontab untuk penjadwalan backup “sysadmin” otomatis yang dilakukan tiap tanggal 1 pada jam 09.00 pagi di setiap bulan.
```sh file
crontab –e #Perintah Terminal

#/tmp/crontab.gxrr2q/crontab
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# m h dom mon dow command

# konfigurasi backup web
0 9 1 * * tar -zcf /home/sysadmin/backup/"abcnet_wordpress.$(date '+\%d-\%m-\%Y-\%H.\%M.\%S').tar.gz" /home/sysadmin/web
# konfigurasi backup database
0 9 1 * * mysqldump -u abcnet -p123456 abcnet_wordpress > /home/sysadmin/backup/"abcnet_wordpress.$(date '+\%d-\%m-\%Y-\%H.\%M.\%S').sql"
```

service cron restart