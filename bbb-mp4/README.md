BigBlueButton toplantılarını MP4 video formatına dönüştürür.

* **add_queue.rb:** Yayınlanan kayıtları dosya kuyruğuna ekler. Betik `/usr/local/bigbluebutton/core/scripts/post_publish` klasörü altında bulunmalı ve çalıştırma izinlerine sahip olmalıdır.
* **recorder.rb:** Dosya kuyruğuna eklenen toplantıların sırasıyla kayıtlarını alarak MP4 formatına dönüştürür ve S3 depolama alanına aktarır.

Kullanmaya başlamadan önce `gem install aws-sdk-s3` komutu ile gerekli kütüphaneler kurulmalıdır.

Depolama alanı bilgileri `/usr/local/bigbluebutton/core/scripts/s3_creds.yml` dosyası içine şu şekilde eklenmelidir;

* **endpoint:** Depolama alanına ait URL adresi.
* **access_key_id:** Erişim anahtarı.
* **secret_access_key:** Gizli anahtar.
* **bucket:** Toplantıların kaydedileceği bucket.
* **region:** Depolama bölgesi. UZEP depolaması için **DEFAULT** kalabilir.

Örnek kullanım şekli;
```
endpoint: https://s3.deneme.com
access_key_id: XXXXXXXXX
secret_access_key: XXXXXXXXX
bucket: bbb-record
region: DEFAULT
```