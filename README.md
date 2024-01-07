| FreeBSD     | BSD Router Project |
| :------------- | :------------- |
| <img src="./assets/images/logo.png" alt="FreeBSD Logo" style="width:200px;"/> | <img src="./assets/images/bsdrp.logo.128.png" alt="FreeBSD Logo" style="width:80px;"/> |


## Catatan hasil belajar FreeBSD support 12.* => terbaru (All in One)

Snapshots Backup/Restore(bectl/beadm)
```
bectl
```
Update Version FreeBSD
```sh tem
freebsd-update fetch #Fetch updates from server
freebsd-update -r 13.2-RELEASE upgrade #Fetch upgrades to FreeBSD version specified via -r option

freebsd-update install #Install downloaded updates or upgrades
#or
bsdinstall

pkg upgrade
```
## 1. Pembelajaran untuk kebutuhan sebagai Workstation
- Cara instan instal DE Dark Meta (Gnome v2) oleh Felix Caffier
```sh
cd /tmp
fetch --no-verify-peer http://trisymphony.com/darkMate -o dm.sh
chmod +x dm.sh
./dm.sh
```
##  2. Pembelajaran untuk kebutuhan sebagai Server
##  3. Pembelajaran untuk kebutuhan sebagai Router

## Sumber belajar
- [FreeBSD Wiki | FrontPage ](https://wiki.freebsd.org/)
- [FreeBSD | Documentation ](https://docs.freebsd.org/en/books/)
- [BSD Router Project | Documentation](https://bsdrp.net/documentation/end-users_docs)
- [Frequently Asked Questions for FreeBSD ](https://docs.freebsd.org/en/books/faq/)
- [FreeBSD Handbook ](https://docs.freebsd.org/en/books/handbook/)
- [FreeBSD Porter's Handbook ](https://docs.freebsd.org/en/books/porters-handbook/)
- [FreeBSD Documentation Project Primer for New Contributors ](https://docs.freebsd.org/en/books/fdp-primer/)
- [Articles | FreeBSD Documentation ](https://docs.freebsd.org/en/articles/)
- [FreeBSD Manual Pages | Check Packages ](https://www.freebsd.org/cgi/man.cgi)
- [Repo Belajar FreeBSD  Indonesia ](http://repo.belajarfreebsd.or.id/)
- [FreeBSD Repo ](http://ftp2.freebsd.org/)
- [CoreBSD Indonesia](http://www.corebsd.or.id/)
- [Wazuh FreeBSD](https://www.freebsd.org/status/report-2023-04-2023-06/wazuh/)
