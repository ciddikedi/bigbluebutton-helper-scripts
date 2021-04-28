Sık kullanılan cron görevlerini ekler.

Yapılan işlemler şu şekildedir;
* Mevcut crontab işlemleri temizlenir. **İsteğe bağlıdır.**
* BBB-record servisi haftanın beş günü saat 08.00'de durdurulur.
* BBB-record-2 servisi haftanın beş günü saat 08.00'de durdurulur. **İsteğe bağlıdır.**
* BBB-record servisi haftanın beş günü saat 20.00'de başlatılır.
* Pazar günleri saat 01.30'da sunucu yeniden başlatılır.
* Toplantıların 28 günden eski kayıtları silinir.
* Toplantılara ait ham dosyaların 28 günden eski kayıtları silinir.

Örnek kullanım şekli;

`ansible-playbook cron.yml -i inventories/example --key-file "~/key.pem"`