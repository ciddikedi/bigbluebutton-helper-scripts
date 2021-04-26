BigBlueButton için çeşitli ihtiyaçlar doğrultusunda oluşturulan betikler.

* **delete-done-folders.sh:** Yayınlanmış ve `presentation.done` dosyası oluşmuş toplantıların geçici dosyalarını `/var/bigbluebutton/` dizninden siler.
* **delete-transfered-meetings.sh:** Ortak depolama alanına aktarılmış toplantı kayıtlarını BBB sunucusu üzerinden siler.
* **delete-transfered-meetings-age.sh:** Ortak depolama alanına aktarılmış belirli günden önceki toplantı kayıtlarını BBB sunucusu üzerinden siler. Betik içerisindeki `MAXAGE` değişkeni düzenlenmelidir.
* **rebuild-non-presentation.sh:** Yayınlanmayan toplantılara rebuild komutu verir.
* **backup-non-build-presentation.sh:** Yayınlanmayan toplantıların raw dosyalarını **rsync** ile main sunuculara yedekler. Betik içerisindeki `mainserver` değişkeni düzenlenmeli ve erişilmek istenen main sunucuya ait private key `~/.ssh/id_rsa` içerisine kaydedilmelidir.