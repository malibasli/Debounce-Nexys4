# FPGA Debounce Durum Makinesi ve Kenar Yakalama

Bu proje, mekanik anahtarlarda (switch/buton) meydana gelen elektriksel sekmeleri (bounce) filtrelemek için tasarlanmış bir VHDL donanım filtresi (Debouncer) uygulamasıdır. Sistem, filtrelenmiş ve filtrelenmemiş iki ayrı anahtarın davranışını donanım üzerinde (Nexys-4 DDR) yan yana karşılaştırarak, debounce işleminin dijital tasarımlardaki kritik önemini kanıtlamaktadır.

## Proje Mimarisi ve Modüller

Proje üç temel VHDL dosyasından ve bir pin eşleştirme (constraint) dosyasından oluşmaktadır:

* **`debounce.vhd` (Ana Filtre):** Mekanik sekmeleri filtreleyen ana durum makinesi (FSM) modülüdür. Sinyalin gerçek bir basım olarak kabul edilmesi için `c_debtime` parametresi ile belirlenen süre (varsayılan 1000, yani 1 ms) boyunca '1' veya '0' seviyesinde kesintisiz kalmasını bekler. Titreşimleri algılamak için 5 farklı durum (`S_INITIAL`, `S_ZERO`, `S_ZEROTOONE`, `S_ONE`, `S_ONETOZERO`) kullanır.
* **`top.vhd` (Ana Tasarım Modülü):** Donanım testinin yapıldığı en üst modüldür. `sw_i(0)` girişini `debounce` modülünden geçirerek temizlerken, `sw_i(1)` girişini tamamen ham bırakır. Her iki sinyalin de yükselen kenarlarını (rising edge) yakalayarak ayrı ayrı 8 bitlik sayaçları artırır. Sayım sonuçlarını eşzamanlı olarak kart üzerindeki LED'lere aktarır ve bir buton yardımıyla sayaçların sıfırlanmasını (senkron reset) sağlar.
* **`tb_debounce.vhd` (Testbench):** Debounce modülünün sanal ortamda doğrulanmasını sağlar. `wait for` komutlarıyla mikrosaniyelik rastgele sekmeler (100 us, 50 us vb.) taklit edilerek, modülün mekanik gürültüleri filtreleyip filtrelemediği Vivado simülasyon ortamında test edilir.

## Donanım Kurulumu (Nexys-4 DDR)

Proje, Xilinx Nexys-4 DDR (Rev. C) FPGA geliştirme kartı için `Nexys-4-DDR-Master.xdc` dosyası ile yapılandırılmıştır.

| Bileşen | Pin (Paket) | Port Adı | Görevi |
| :--- | :--- | :--- | :--- |
| **Sistem Saati** | E3 | `clk` | 100 MHz Sistem Saati (Clock) |
| **Switch 0** | J15 | `sw_i[0]` | Filtreli Giriş (Debounced) |
| **Switch 1** | L16 | `sw_i[1]` | Filtresiz Giriş (Raw/Bouncy) |
| **Orta Buton** | N17 | `button_i` | Sayaçları Sıfırlama (Reset) |
| **LED'ler [7:0]** | U16 ... H17 | `led_o[7:0]` | Filtreli Switch Sayacı (counter_sw1) |
| **LED'ler [15:8]** | V11 ... V16 | `led_o[15:8]` | Filtresiz Switch Sayacı (counter_sw2) |

## Beklenen Çalışma Senaryosu (Donanım Testi)

Bitstream oluşturulup FPGA'e yüklendiğinde sistem şu şekilde tepki verecektir:

* **Filtreli Anahtar Testi (`sw_i[0]`):** Anahtarı her yukarı kaldırdığınızda, sağ taraftaki ilk 8 LED'de (`led_o[7:0]`) tutulan sayaç değeri kusursuz bir şekilde sadece 1 artacaktır.
* **Filtresiz Anahtar Testi (`sw_i[1]`):** Anahtarı yukarı kaldırdığınızda, sol taraftaki 8 LED'de (`led_o[15:8]`) tutulan sayaç değeri, mekanik kontakların mikroskobik düzeydeki sekmeleri yüzünden tek bir fiziksel basımda rastgele sayılarda (örneğin 3, 7 veya 12 sayı birden) artış gösterecektir.
* **Sıfırlama:** Kartın ortasındaki `button_i` (BTNC) butonuna basıldığında her iki sayaç da eşzamanlı olarak sıfırlanacaktır.
