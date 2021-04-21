BigBlueButton için çeşitli ihtiyaçlar doğrultusunda oluşturulan betikler.

* **delete-done-folders.sh:** Yayınlanmış ve `presentation.done` dosyası oluşmuş toplantıların geçici dosyalarını `/var/bigbluebutton/` dizninden siler.
* **delete-transfered-meetings.sh:** Ortak depolama alanına aktarılmış toplantı kayıtlarını BBB sunucusu üzerinden siler.
* **delete-transfered-meetings-age.sh:** Ortak depolama alanına aktarılmış belirli günden önceki toplantı kayıtlarını BBB sunucusu üzerinden siler. Betik içerisindeki `MAXAGE` değişkeni düzenlenmelidir.