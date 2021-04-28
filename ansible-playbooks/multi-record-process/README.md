İkinci recorder process servisini ekler.

Bunun yanında;
* Toplantıları işlemek için gereken ffmpeg parametrelerini **4 thread** ve **fast preset** olarak değiştirir.
* Varsayılan video formatını **mp4** olarak ayarlar.

Örnek kullanım şekli;

`ansible-playbook playbook.yml -i inventories/example --key-file "~/key.pem"`