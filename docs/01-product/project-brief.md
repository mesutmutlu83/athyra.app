# Sportapp — Uygulama Verisine Dayalı Dijital Antrenör
## Ürün Özellikleri ve Geliştirme Planı

**Sürüm:** 6.0 — P0 web admin paneli, üyelik/ücret takibi ve minimum CRM + iOS/iPhone 12 ve sonrası + çok sporlu katalog + uygulama verisi + kayıt/giriş + ayrıştırılmış izinler  
**Tarih:** 25 Eylül 2026  
**Dil:** Türkçe  
**Hedef okuyucu:** Uygulamayı geliştirecek kodlama LLM’i, ürün sahibi ve geliştirme ekibi.  
**Belge türü:** Ürün gereksinimleri, entegrasyon sınırları, mimari, backlog, geliştirme sırası ve kabul kriterleri. Görsel UI tasarım rehberi değildir.

> **Bağlayıcı kapsam:** Sportapp ölçüm yapmaz; saat, bileklik, sensör veya spor ekipmanına bağlanmaz. Apple Health, Google Health, Huawei Health, Samsung Health gibi uygulamaların izinli olarak sunduğu mevcut verileri okur. Haftalık plan oluşturur, gerçekleşenleri değerlendirir, planı uyarlar ve antrenöre karar desteği sağlar. Antrenmanın kaydı dış uygulamaların sorumluluğundadır.

> Bu belge `Sportapp_Feature_List_Development_Plan_TR_v5_iOS_iPhone12.md` (v5.0) yerine geçen tam dokümandır; yalnızca bir değişiklik eki değildir. İlk kullanıcı ürünü native iPhone uygulamasıdır: sporcu ve antrenör işlevleri aynı uygulamada rol bazlıdır. **Ürün sahibi/operasyon ekibi için web admin paneli P0’dır; kayıtlı kullanıcılar, üyelikler, ücret/ödeme durumu ve minimum CRM burada yönetilir.** Ayrı antrenör web istemcisi P1/opsiyoneldir, Android ilk yayın teslimatı değildir. iPhone 12 ailesi ve sonraki iPhone’lar hedeflenir; tarihsel iOS kapsamı ile doğrulanmış derleme/yayın desteği Bölüm 1.6’da açıkça ayrılır. Haftalık plan, adaptasyon, antrenör, uygulama verisi ve platform LLM/BYOK kapsamı korunmuştur. Önce mevcut projeyi incele ve gereksinimlerle karşılaştır. Doğrulanmamış entegrasyonları tamamlanmış gösterme. Önceki belgede yer alan cihaz eşleştirme, antrenman başlatma/duraklatma, sensör kaydı ve saate program gönderme varsayımlarını P1/P2’ye ertelemek yerine kapsamdan kaldır.

### v5’ten v6’ya değişiklik özeti

| Konu | v6 kararı |
|---|---|
| İlk yayın yüzeyleri | Native iPhone sporcu/antrenör uygulaması + tarayıcıdan çalışan özel web admin paneli + ortak backend/worker/AI. Admin web’i, P1 antrenör web’i değildir. |
| Kullanıcı yönetimi | Kayıt, doğrulama, rol, hesap durumu, son giriş, üyelik, iletişim ve destek bilgilerine yetkili erişim. |
| Üyelik ve ücret | Ücretsiz/karşılanan, süreli/tek seferlik veya seçilirse abonelik modellerini ayıran üyelik, fiyat, işlem ve erişim hakkı takibi. Herkesi aboneliğe geçirme kararı verilmiş değildir. |
| Ödeme doğruluğu | Sağlayıcı doğrulaması, ortam ayrımı, yinelenen/sırası değişen bildirim, iade/iptal ve mutabakat. Elle ödeme işaretleme, App Store kurallarını aşma yöntemi değildir. |
| Minimum CRM | Mevcut üyeden oluşan kullanıcı kartı, etiket, idari not, iletişim geçmişi, sorumlu, takip görevi ve basit destek kaydı. Tam satış/marketing otomasyonu yok. |
| Yetki/gizlilik | Davetli yönetici + MFA; DB tabanlı roller/izinler; destek ve finans ayrımı; sağlık verisi, antrenör notu ve BYOK anahtarı genel CRM verisi değildir. |
| Kapsam tutarlılığı | Önceki “web P0 değil” ifadeleri yalnızca antrenör/tüketici web’ini kapsayacak biçimde düzeltildi; admin API, ekran, veri modeli, plan ve testlere işlendi. |
| Korunanlar | iPhone 12 ve sonrası, açık iOS uyumluluk kararı, tüm spor kataloğu, ilk/sonraki haftalık plan, adaptasyon, antrenör, login, ayrı izinler ve platform LLM/BYOK. Ölçüm/cihaz bağlantısı yok. |

**Ödeme iş modeli kararı — BILLING-001:** Ücretin kime/ne için alınacağı, tek seferlik mi dönemsel mi olduğu, para birimi, fiyat, vergi/fatura sorumluluğu, hedef mağaza ve ödeme kanalı D0’da kaydedilir. Belge gerçek fiyat veya zorunlu abonelik uydurmaz. Üyelik/ücret takibi P0’dır; gerçek tahsilat yalnızca seçilen kanalın doğrulama/yayın koşulları tamamlanınca açılır. Diğer işlerin geliştirilmesi bu ticari karar yüzünden durdurulmaz.

### Önceki v4 → v5 kapsam değişiklikleri — korunmuştur

| Konu | v5 kararı |
|---|---|
| İlk yayın | Native iOS/iPhone uygulaması + gerekli backend/worker/AI servisleri; web sitesi veya PWA, iOS teslimi yerine geçmez. v6 ile özel admin web paneli ayrıca P0’dır. |
| Roller | Sporcu ve antrenör P0’da aynı iPhone uygulamasında. Antrenör özellikleri silinmez; masaüstü web karşılıkları P1 olur. |
| Cihaz hedefi | iPhone 12, 12 mini, 12 Pro, 12 Pro Max ve daha sonra çıkan iPhone aileleri; yalnızca Pro/Apple Intelligence cihazlarıyla sınırlama yok. |
| iOS kapsamı | Kullanıcının cihazların desteklediği sürümlere ilişkin geniş isteği korunur. iOS 14.x için güncel destekli araç zinciri açığı görünür; iOS 15.0 pratik mühendislik tabanı önerisidir, onaylanmış kapsam daraltması değildir. |
| Geriye uyumluluk | Minimum OS, build SDK, test runner/runtime, kaynak uygulama ve API yeteneği ayrı; yeni API kullanan ekranlarda işlevsel alternatif gerekir. |
| Test/yayın | Cihaz × kurulabilir iOS sürümü × kaynak uygulama/özellik matrisi, iPhone 12/mini performansı, gerçek cihaz kanıtı ve App Store arşiv kontrolü. |
| Korunanlar | Tüm çok sporlu katalog, haftalık plan, adaptasyon, antrenör, Apple/Google/e-posta giriş, izinler, platform LLM ve BYOK. Ölçüm veya cihaz bağlantısı eklenmez. |

**Önemli açık karar — IOS-SUPPORT-001:** iPhone 12’nin tarihsel iOS 14.x desteği ile güncel Apple araç zincirinin belgelenmiş deployment tabanı aynı değildir. Doküman iOS 14’ü destekliyormuş gibi göstermez ve bu isteği sessizce iOS 17/18/26+ koşuluna dönüştürmez. D0’da bu fark ürün sahibiyle kayıtlı biçimde çözülmeden “bütün desteklediği sürümler” pazarlama vaadi veya uyumluluk tamamlandı sonucu yayımlanamaz. Engel dışındaki geliştirme devam eder. [S46][S47][S48]

### Önceki v3 → v4 kapsam değişiklikleri — korunmuştur

| Konu | v4 kararı |
|---|---|
| Hedef kitle | Koşu/kuvvet/HYROX örneklerdir; yarış hedefi olsun veya olmasın tek ve çok sporlu yetişkin kullanıcılar. |
| Branş kapsamı | HIIT, fonksiyonel, Pilates, yoga, mobilite, yüzme, bisiklet, takım/raket/doğa/kış/su sporları ve genişletilebilir diğer branşlar. |
| Kategoriler | Spor/alt tür, yöntem/seans biçimi, hareket/drill/poz, kas bölgesi, hareket örüntüsü, ekipman ve seviye ayrı çoktan-çoğa filtreler. |
| Garmin referansı | Pinlenmiş resmî FIT spor/alt spor/hareket sözlüklerinin tam import gereksinimi; model bazlı menü adları ve marka bağımsız Sportapp içerikleri ayrı. Cihaz bağlantısı değil. |
| Planlama | Branşa özgü tipli seanslar; aynı hafta farklı sporlar; yarış dışı hedefler; ortak ama veriye duyarlı adaptasyon. |
| İçerik yönetişimi | Kaynak/hash/sürüm, lisans, çeviri, kas/ekipman sınıflandırması, uzman incelemesi, özel antrenör içeriği ve katalog güncellemesi. |
| Geliştirme ve testler | Katalog; veri modeli, LLM araçları, API, ekranlar, D0–D10 ve kabul testlerine işlendi. |
| Korunan kapsam | Haftalık plan, adaptasyon, antrenör, platform LLM/BYOK, e-posta/Apple/Google login ve ayrı izinler. Ölçüm, cihaz, sensör, kayıt timer’ı ve saate gönderim yok. |

**Kapsam:** 230 özellik (217 P0, 12 P1, 1 P2), 11 geliştirme aşaması ve 220 kabul/test senaryosu. v5’teki 194 özellik kimliği ve 180 senaryo korunmuştur; 14 ADMIN, 14 BILL ve 8 CRM özelliği ile 40 senaryo eklenmiştir. Ayrı antrenör web sunumu P1 kalır; özel admin web’i P0’dır. Sayılar gereksinim adetleridir; çalıştırılmış uygulama testi, hazır egzersiz, efor veya teslimat süresi değildir. Katalog kaydı, uzman onaylı koçluk içeriği ve gerçek tahsilat kanıtı birbirinden ayrıdır.

---

## 1. Ürünün amacı ve bağlayıcı kararlar

Sportapp, diğer sağlık ve fitness uygulamalarından alınan geçmiş ve güncel kayıtları; kullanıcının hedefleri, uygunluğu ve kısa geri bildirimleriyle birleştiren bir **antrenman planlama, değerlendirme ve uyarlama uygulamasıdır**. Sporcu kendi başına veya yetkilendirdiği antrenörle aynı spor geçmişi üzerinde çalışabilir.

Temel sorular birlikte cevaplanmalıdır:

**“Hedeflerime hazırlanmak için bu hafta nasıl çalışmalıyım?”**  
**“Dış uygulamalarda görülen gerçekleşen antrenmanlarım ve bugünkü koşullarım nedeniyle şimdi ne yapmalıyım?”**

### 1.1 Bağlayıcı ürün kararları

- İlk istemci native iOS/iPhone uygulamasıdır; iPhone 12 ailesi ve sonraki iPhone modelleri hedeflenir. Sporcu ve antrenör deneyimleri aynı uygulamada rol bazlı sunulur. Android, ayrı iPad/macOS istemcisi ve antrenör web’i ilk yayın için zorunlu değildir. Buna karşılık ürün sahibi için özel web admin paneli, üyelik/ücret takibi ve minimum CRM ilk yayın kapsamındadır. Sürüm kapsamı ve açık iOS 14 kararı Bölüm 1.6’ya tabidir. Hedef kullanıcı, tek veya birden çok spor/aktivite yapan yetişkindir; yarışa hazırlık zorunlu değildir. Koşu, kuvvet ve HYROX yalnızca örnektir. HIIT, fonksiyonel, Pilates ve diğer branşlar kategorili, genişletilebilir içerik ve branşa uygun planlama ile desteklenir.
- E-posta + şifre, Apple ile kayıt/giriş ve Google ile kayıt/giriş P0’dır; sporcu ve antrenör aynı iPhone uygulamasında aynı kimlik altyapısını kullanır. P1 antrenör web’i eklendiğinde aynı hesaplara bağlanır. Login kimliği, sağlık kaynak izni, platform işleme ve AI/antrenör paylaşımı ayrı yönetilir.
- Sağlık kaynağı bağlama, bütün veri kategorilerine izin verme veya bildirim izni hesabın kullanılmasının zorunlu koşulu değildir. Yeni hesap/oturum sağlık iznini kendiliğinden miras almaz.
- Haftalık plan oluşturma, ayrıntılı seans reçetesi, dış uygulamalardan gerçekleşenleri izleme ve günlük/haftalık uyarlama P0’dır.
- **Ölçüm, sensör erişimi, cihaz eşleştirme ve canlı antrenman kaydı hiçbir geliştirme aşamasının parçası değildir.** WatchOS/Wear OS uygulaması veya cihaz SDK’sı ekleme.
- Veri okumak için diğer uygulamaların desteklediği resmî mekanizmalar kullanılır. Bir uygulamanın telefonda kurulu olması, içindeki tüm verilere erişim vermez. iOS uygulamalarının özel depoları diğer uygulamalara açık değildir. [S20]
- Sağlık verisi entegrasyonları salt okunurdur. Sportapp dış sağlık depolarında kayıt oluşturmaz, düzeltmez, silmez; ölçülmemiş planı gerçekleşmiş antrenman olarak dışarı yazmaz.
- LLM, ihtiyaç anlama, dönem/hafta taslağı, alternatifler, açıklama ve sohbet görevlerinde gerçek planlama bileşenidir; yalnızca metin süsleyicisi değildir.
- Varsayılan AI, ürün sahibinin yönettiği LLM servisidir. Model, donanım veya servis üreticisine bağımlı tasarım yapılmaz.
- Kullanıcı P0’da kendi API anahtarıyla desteklenen AI servisini veya güvenlik kontrolünden geçmiş OpenAI-compatible endpoint’i kullanabilir. BYOK, kullanıcının kendi API anahtarını kullanmasıdır.
- Seçilen AI bağlantısı yeteneği ölçüsünde haftalık planı ve günlük uyarlamayı da üretir; BYOK yalnızca sohbet için göstermelik değildir.
- Model değişse de sporcu geçmişi, planlar, yetkiler ve kontroller aynı uygulama altyapısında kalır.
- Antrenör manuel veya AI ile plan oluşturabilir, düzenleyebilir ve uyarlama yetkilerini belirleyebilir. Sporcu antrenör değiştirince geçmişini kaybetmez.
- Sağlık uygulamasına erişim izni, AI sağlayıcısına veri gönderme izni ve antrenöre paylaşım izni ayrıdır. AI anahtarı veri erişim yetkisi değildir.
- Veri yoksa “bilinmiyor” denir. Hazırlık/toparlanma değerlendirmesi ölçüm veya tanı olarak sunulmaz; doğrulanmamış kesin nabız, performans veya sakatlık iddiası üretilmez.

- **P0 web yönetimi:** Admin paneli kayıtlı kullanıcıları, üyelikleri, fiyat/ödeme kayıtlarını, takip görevlerini ve destek süreçlerini yönetir. Yönetici olmak antrenör/sağlık paylaşım onayını devralmaz.
- **Hesap ≠ üyelik ≠ ödeme ≠ veri izni:** Ödeme veya ücretsiz yetki vermek rol yükseltmez, sağlık/AI/antrenör paylaşımını açmaz. Üyelik sonu hesabı/veriyi silmez; hesap askısı Apple aboneliğini otomatik iptal etmez.
- **Ticari esneklik:** Ücretsiz kullanım, bedelsiz süreli erişim ve uygun ücretli seçenekler modellenir. Abonelik zorunluluğu, birim fiyat ve ödeme sağlayıcısı bu talepten varsayılmaz. P0 ücret takibi korunur; ticari kanal açılışı BILLING-001 ile doğrulanır.

### 1.2 Üç farklı bilgi türü

| Tür | Örnek | Sportapp’ın rolü |
|---|---|---|
| **İçe aktarılmış kayıt** | Dün tamamlanan koşu, son gece uyku, kaynak uygulamanın verdiği nabız/VO₂max | Kaynağı, tarihi, tanımı ve aktarım yoluyla birlikte okumak. |
| **Kullanıcı/antrenör beyanı** | “Bacaklarım yorgun”, “30 dakikam var”, “Kayıt açmadan basketbol oynadım” | İsteğe bağlı beyan olarak saklamak; sensörle doğrulanmış saymamak. |
| **Sportapp analizi/önerisi** | Geçen sürenin hesabı, haftalık yük özeti, uygun seans ve hedef yoğunluk | İzinli girdilerden türetmek; yöntem/sürüm ve belirsizliği belirtmek. |

**Analiz yapmak ölçüm yapmak değildir.** Sportapp içe aktarılmış süre ve mesafeden ortalama tempo hesaplayabilir; bunu doğrudan ölçtüğünü söylemez. Planın hedef nabzı bir öneridir; kullanıcının o anda ölçülen nabzı değildir. Kaynakta bulunmayan bir VO₂max değeri veya uyku evresi üretip ölçülmüş veri sütununa yazılmaz.

### 1.3 Kapsam dışı işlevler — sonraki fazlara da eklenmeyecek

Bluetooth/BLE veya ANT+ eşleştirme; sensör/cihaz arama; Core Motion ile adım/aktivite ölçme; GPS rota kaydetme; kamera ile nabız/tekrar ölçme; canlı nabız ekranı; workout recording oturumu; başlat/duraklat üzerinden süre ölçümü; saat uygulaması; saate plan gönderme; spor ekipmanını uzaktan yönetme.

HealthKit kullanılması bu işlevlerin yapılacağı anlamına gelmez: yalnızca mevcut kayıtları okuyan API yüzeyi kullanılacaktır. Apple’ın sağlık veri deposu ile Motion/Location gibi ölçüm araçları farklı yeteneklerdir. [S4]

Uygulama içi haftalık planı düzenlemek, geri bildirim saklamak ve kendi backend’ine izinli veri aktarmak serbesttir; **salt okunur sınır dış sağlık kaynağı için geçerlidir**.

### 1.4 Öneriler ve varsayımlar

Bu belgedeki mimari öneriler mevcut Sportapp kod tabanına ait doğrulanmış bilgiler değildir. Başka projelerin reposu, donanımı veya AI ayarı bu projeye ait kabul edilmez. Antrenman örnekleri test senaryosudur; gerçek sporcuya reçete değildir. Bir sağlayıcının belgelerde bir özelliği sunması, Sportapp entegrasyonunun geliştirilmiş olduğu anlamına gelmez.

### 1.5 Çok sporlu kapsam — örnekler hedef kitle sınırı değildir

Ürün; tek bir spor yapan veya farklı sporları aynı haftada birleştiren yetişkinlere ve onları çalıştıran antrenörlere yöneliktir. Yarışa hazırlanmak, performans süresi veya VO₂max sahibi olmak giriş şartı değildir. Düzenli hareket alışkanlığı, genel kondisyon, kuvvet, teknik beceri, mobilite, Pilates/yoga pratiği ve rekreatif spor devamlılığı da hedef olabilir. Koşu, kuvvet ve HYROX önceki konuşmalarda yalnızca örnekti.

**Bağlayıcı katalog kapsamı:** Koşu/yürüyüş, bisiklet, yüzme, kuvvet, HIIT, fonksiyonel antrenman, hibrit/HYROX, Pilates, yoga, mobilite/esneme, kardiyo/ergometre, takım ve raket sporları, dövüş sporları, dans/gimnastik, tırmanış/doğa, kış ve su sporları, çoklu spor ve uyarlanmış/oturarak yapılan aktiviteler tek genişletilebilir modelde temsil edilir. Garmin'in resmî, sürümü belirlenmiş FIT spor/alt spor/egzersiz sözlükleri içeri alma ve eşleme için başlangıç referansıdır; ürünün üst sınırı veya kullanıcıya dayatılan kategori sistemi değildir. [S37][S38]

**Garmin referansı ≠ Garmin cihaz bağlantısı.** Bu çalışma spor ve hareket adlandırma/kategorileme içeriğine ilişkindir. Cihaz eşleştirme, saat uygulaması, sensör, kayıt başlatma ve saate gönderme kapsam dışı kalır. Bir katalog öğesinin bulunması o hareketin kaynak sağlık uygulamasından ayrıntılarıyla okunabildiğini göstermez.

**Katalog kapsamı ≠ otomatik koçluk olgunluğu.** Kaynaktaki türleri tanıma, geçmişte gösterme ve manuel/antrenör planına yerleştirme geniş kapsamlı P0 gereksinimidir. Ayrıntılı AI planı/adaptasyonu; branşın doğrulanmış içerik, doz şeması, politika, kullanıcı seviyesi ve veri yeterliliğiyle açılır. Bu ayrım, HIIT/Pilates/fonksiyoneli ilk sürümden çıkarmak için kullanılamaz: Bölüm 11'deki ana paketler P0 yayın kapısına dahildir. Uzmanlık gerektiren branşta destek seviyesi açık gösterilir; yalnızca spor adı eklemek “tam dijital antrenör” sayılmaz.

### 1.6 iOS ilk yayın ve cihaz/işletim sistemi uyumluluk sözleşmesi

**Kullanıcının asıl gereksinimi:** İlk ürün iOS uygulamasıdır; iPhone 12 ve sonrası telefonlarda ve bu telefonların desteklediği iOS sürümlerinde çalışmalıdır. Bu gereksinim “yalnızca en yeni iPhone” veya “yalnızca en son iOS” diye daraltılmaz. Bununla birlikte bir telefonun geçmişte çalıştırabildiği OS, bugün Apple’ın desteklediği derleme hedefi, o telefona kurulabilen sürüm ve test edilmiş Sportapp sürümü aynı kavram değildir.

#### 1.6.1 Donanım kapsamı

iPhone 12, 12 mini, 12 Pro ve 12 Pro Max temel ailedir. Sonraki iPhone aileleri ile bu ailelerin mini/Plus/Pro/Pro Max/e/Air gibi varyantları, Apple’ın resmî model ve OS kayıtlarına göre destek matrisine alınır. “Sonrası” yalnızca sayısal pazarlama adına bakılarak yorumlanmaz: örneğin daha sonra çıkan SE modelleri tarih/yetenek bazında ayrıca değerlendirilir; dışlanacaksa açık ürün kararı gerekir. iPhone 12 mini küçük ekran ve alt donanım test hedefidir. Yeni/yeni biçimli iPhone’da uyarlanabilir yerleşim gerekir; henüz test edilmemiş model için test yapılmış iddiası yoktur.

Apple’ın kontrol edilen iOS 27 uyumluluk sayfasında iPhone 12 ailesi yer alır. Bu, Sportapp’ın o sürümde çalıştığının test kanıtı değildir. Model/OS listesi yayın anında tekrar doğrulanır. [S49]

**Destek hedefi ≠ mağazadan diğer modelleri yapay olarak engelleme.** Kullanıcı daha eski iPhone’ları yasaklamayı istememiştir. `UIRequiredDeviceCapabilities` yalnızca gerçekten gereken yetenekler için kullanılabilir; LiDAR, ARKit, Bluetooth veya uydurma “minimum-iPhone12” anahtarı ile model eleme yapılmaz. Donanım kimliklerini pazarlama numarasıyla karıştıran veya bilinmeyen gelecek modelleri açılışta reddeden karşılaştırmalar yazılmaz. Eski modelde fiilen çalışması otomatik resmî destek taahhüdü yaratmaz. [S50]

#### 1.6.2 iOS sürümleri — istek, teknik öneri ve kanıt ayrımı

| Katman | Bu dokümandaki durum | Bağlayıcı davranış |
|---|---|---|
| İstenen kapsam | Hedef iPhone modellerinin çalıştırabildiği yayımlanmış iOS sürümleri | Tarihsel kapsamı sessizce silme; cihaz başına gerçekten kurulabilir sürümleri dikkate al. |
| Tarihsel alt kol | iPhone 12 iOS 14 ile tanıtıldı; 14.x bu geniş isteğin parçasıdır. | Güncel destekli araç zinciri ve mağaza yolu için `OPEN_PLATFORM_GAP`; çalışıyor kabul edilmez. [S48] |
| Pratik mühendislik tabanı | **iOS 15.0 önerisi**, henüz kullanıcı tarafından onaylanmış kapsam daraltması değil | D0 prototip/bağımlılık çalışmaları bu tabanla ilerleyebilir; nihai ürün desteği kararı `IOS-SUPPORT-001` ile kaydedilir. |
| Yayımlanmış sonraki sürümler | Modelin gerçekten çalıştırabildiği 15/16/17/18/26/27 ana sürüm kolları; liste kaynak tarihine bağlı | Her kolun uygun nokta sürümleri için test kapsamı ve kanıt kaydı; 19–25 gibi yayımlanmamış varsayımsal kollar üretme. |
| Gelecekteki iOS / beta | Henüz doğrulanmamış uyumluluk | Beta regresyon hattı ayrı; gelecek bütün sürümlerde koşulsuz çalışma garantisi verme. |

**Dış kaynak bulgusu:** Apple’ın kontrol edilen Xcode tablosunda Xcode 26/27 için iOS deployment tabanı 15 olarak listeleniyor. Mağaza yükleme kuralı ise 28 Nisan 2026’dan itibaren Xcode 26+/ilgili 26 SDK’sını; ayrıca 9 Eylül 2026’dan itibaren en az iOS 13 hedefini belirtiyor. Bunlar aynı sınır değildir: iOS 14 “App Store tarafından kesin yasak” sonucu çıkarılamaz, fakat bu kaynaklar iOS 14 için güncel destekli bir araç zinciri de doğrulamıyor. Bu yüzden destek iddiası değil açık fark kaydı gerekir. [S46][S47]

`IOS-SUPPORT-001` kaydında: talep edilen tarihsel kapsam, destekli araç/SDK ve bütün bağımlılıklar, gerçek cihaz ve imzalı binary doğrulaması, mağaza kabul durumu, güvenlik/bakım maliyeti ve ürün kararı bulunur. iOS 14 için destekli/dağıtılabilir yol kanıtlanırsa ayrı doğrulamayla kapsama alınır; kanıtlanamazsa 15.0 tabanı ancak açık kapsam kararıyla kesinleşir. Eski veya destek dışı derleyici hilesi, güvenlik bakımını kesmiş bağımlılık ya da yalnızca `IPHONEOS_DEPLOYMENT_TARGET=14.0` yazmak çözüm kanıtı değildir. Açık karar P0 geliştirmeyi durdurmaz; **tam sürüm kapsamı onayını ve yanıltıcı yayın beyanını engeller**.

#### 1.6.3 Kurulabilirlik ve işlevsel destek

Bir telefonun çıkışından önceki iOS sürümü o telefona zorla yüklenmez. Yeni iPhone’da eski iOS’u çalıştırma testi, destek matrisinde `NOT_INSTALLABLE` olur; başarısız test veya ürün açığı sayılmaz. Apple’ın imzalamadığı eski sürüme kolayca downgrade yapılacağı varsayılmaz. Tarihsel OS testi için uygun sürümde korunmuş gerçek telefon/test cihazı ve destekli dağıtım yolu gerekir.

Resmî destek yalnızca uygulamanın açılması değildir: kayıt/giriş, izinler, çok sporlu katalog, ilk haftalık plan, günlük uyarlama, antrenör onayı, platform LLM/BYOK, paylaşım ve silme akışları ilgili sürümde çalışmalıdır. Yeni API’ye özgü görsel iyileştirme atlanabilir; temel işlev sessizce kaldırılmaz. Bir dış sağlık uygulamasının daha yüksek minimum iOS istemesi, Sportapp’ın kendi minimumunu otomatik yükseltmez: ilgili bağlantı kısıtı gösterilir; izinli mevcut HealthKit kayıtları ve manuel bağlamla devam edilebilir.

#### 1.6.4 İlk yayın yüzeyleri

P0 kullanıcı yüzeyi native iPhone’dur. Ayrı Android uygulaması/Health Connect okuyucusu, optimize iPad uygulaması, Mac/Catalyst uygulaması veya web antrenör istemcisi P0 zorunluluğu değildir. Antrenör yetenekleri aynı iPhone uygulamasında kalır; web sürümü P1’e taşınırken işlevler silinmez. **P0 web admin paneli ayrıca gereklidir:** kayıtlı kullanıcı/üyelik/ücret/CRM ve yetkili iç operasyon ekranları tarayıcıdan kullanılabilir olmalıdır. Sadece admin API’si veya SQL/CLI vermek yeterli değildir. API, veritabanı, worker ve AI gateway korunur; “iOS ilk” her şeyi telefonda/offline çalıştırmak veya yönetim web’ini ertelemek anlamına gelmez. Web/iPad uyumluluk çalıştırması ile resmî ayrı platform ürünü birbirine karıştırılmaz.

## 2. Kullanıcılar, roller ve karar yetkisi

| Rol | İzin verilen ana işlemler | Sınır |
|---|---|---|
| Sporcu | Hedef, uygunluk, veri bağlantısı, AI seçimi, plan onayı, günlük geri bildirim, paylaşım | Başka sporcu verisine erişemez; güvenlik kontrollerini prompt ile kaldıramaz. |
| Antrenör | Yetkili sporcuları görme, plan hazırlama, seans düzenleme, öneri onaylama, not alma | Yalnızca sporcunun verdiği kapsam; API anahtarlarını veya izinsiz hassas verileri göremez. |
| Organizasyon yöneticisi | P1: ekip, antrenör üyelikleri, operasyonel ayarlar | Yönetici rolü otomatik olarak sağlık verisi erişimi sağlamaz. |
| Platform sahibi / yönetici | P0 web admin; kullanıcı/üyelik yönetimi, CRM, yetkili fiyat/işlem takibi, servis/politika ve sistem sağlığı | MFA + DB izinleri; ham sağlık, koç özel notu ve açık kullanıcı API anahtarına varsayılan erişim yok. |
| Destek yetkilisi | P0 web; yetkili kullanıcı kartı, idari not, destek kaydı ve görev | Fiyat/ödeme/rol değiştiremez; ödeme özeti yalnızca gereken dar kapsamda. |
| Finans yetkilisi | P0 web; fiyat/üyelik/ödeme raporu, mutabakat ve izinli mali işlemler | Sağlık/koç içeriği ve kullanıcı anahtarları yok; personel rolü veya AI alıcısı değiştiremez. |

Bir kullanıcı hem sporcu hem antrenör olabilir. Kişisel sporcu hesabı ile antrenör olarak yönettiği müşteriler açıkça ayrılır. Admin personel üyeliği `AdminStaffMembership` ile ayrıca verilir; mobil rol seçimi veya aynı e-posta alan adı yönetici oluşturmaz. Aynı User kimliği kullanılsa bile web admin oturumu ayrı MFA/kapsam ister; kişisel uygulama oturumu admin oturumu yerine geçmez.

**Koçluk modları:**

1. **Bağımsız sporcu:** AI taslağı sporcu onayıyla yayımlanır. Sporcu önceden izin verdiği sınırlı uyarlamaları otomatikleştirebilir.
2. **Antrenör onaylı:** AI değişiklik taslağı üretir; yayımlamak için antrenör onayı gerekir.
3. **Sınırlı otomatik uyarlama:** Antrenörün ve sporcunun izin verdiği kapsam içinde küçük değişiklikler uygulanabilir. İzin verilmeyen veya önemli değişiklikler onay ister.

Bir planda tek bir aktif yayınlama otoritesi bulunmalıdır. Birden çok antrenörün aynı anda farklı sürüm yayımlaması önlenir. Sporcu son onaylı planından ayrılabilir ve bunu gerçekleşen aktivite olarak kaydedebilir; sistem geçmişi kullanıcı davranışına uydurmak için değiştirmez.

### 2.1 Özellik listesi — Kayıt, giriş ve hesap yönetimi

Bu bölümdeki P0 işlevler ilk sürüm kapsamındadır. Üç giriş yöntemi aynı kalıcı Sportapp hesabına erişebilir: **e-posta + şifre, Apple ile devam et, Google ile devam et**. Sosyal girişte ilk başarılı doğrulama kayıt, sonraki doğrulamalar giriş işlevini görür; kullanıcıya ayrıca bir Sportapp şifresi oluşturma zorunluluğu getirilmez.

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| AUTH-01 | P0 | E-posta ile kayıt | Minimum hesap bilgisi, e-posta + şifre, koşul kabulü; sağlık/AI/pazarlama onaylarıyla birleştirme yok. |
| AUTH-02 | P0 | E-posta doğrulama | Süreli, tek kullanımlık link/kod; tekrar gönderme sınırı, yanlış adres düzeltme ve kaldığı yerden devam. |
| AUTH-03 | P0 | E-posta ile giriş | Güvenli şifre kontrolü, genel hata mesajı, kötüye kullanım sınırları; giriş rol veya sağlık izni sağlamaz. |
| AUTH-04 | P0 | Apple ile kayıt/giriş | Resmî Sign in with Apple; P0 native iPhone sporcu/antrenör, P1 antrenör web karşılığı; sunucuda doğrulama ve aynı iç kullanıcı kimliği. |
| AUTH-05 | P0 | Google ile kayıt/giriş | P0 resmî native Google Sign-In; P1 antrenör web karşılığı; minimum kimlik kapsamı, sunucu doğrulaması; sağlık OAuth izni istemeden giriş. |
| AUTH-06 | P0 | Sosyal ilk/tekrar giriş | Yeni kullanıcıya kısa başlangıç; mevcut kullanıcıya aynı hesap. İptal/hata boş hesap ve iki sporcu profili oluşturmaz. |
| AUTH-07 | P0 | Şifremi unuttum / sıfırlama | Hesap varlığını açıklamayan yanıt, süreli/tek kullanımlık token, yeni şifre ve eski oturumları geçersiz kılma. |
| AUTH-08 | P0 | Şifre / iletişim adresi değiştirme | Yeniden kimlik doğrulama; yeni adres teyidi, güvenlik bildirimi ve mevcut izinlerin korunması. |
| AUTH-09 | P0 | Giriş yöntemi bağlama / kaldırma | Mevcut hesabın ve yeni yöntemin sahipliği doğrulanır; son kullanılabilir yöntem yanlışlıkla kaldırılamaz. |
| AUTH-10 | P0 | Çakışan hesap ve private relay | E-posta benzerliğiyle otomatik birleştirme yok; Apple gizli e-posta desteği; doğrulanmış çözüm akışı. |
| AUTH-11 | P0 | Oturum ve yenileme yönetimi | Sportapp oturumu dış sağlayıcı token’ından ayrı; süre, yenileme, iptal, tekrar kullanma ve istemci bazlı kapsam. |
| AUTH-12 | P0 | Çıkış / tüm oturumlardan çıkış | İlgili oturumlar iptal; yerel hassas cache/kuyruk ve push eşlemesi temizlenir; hesap silinmez. |
| AUTH-13 | P0 | Oturum listesi | P0 iPhone ve yetkili personelin web admin oturumları; P1 antrenör web’i eklenirse onun oturumları; son kullanım ve tek oturumu sonlandırma; giyilebilir listesi değildir. |
| AUTH-14 | P0 | Hassas işlemde yeniden doğrulama | Hesap silme, giriş yöntemi değişikliği, tam sağlık export’u gibi işlemlere kısa ömürlü, işleme bağlı yetki. |
| AUTH-15 | P0 | Sporcu / antrenör başlangıcı | Tek kullanıcı iki role sahip olabilir; rol seçimi başka sporcunun verisine erişim sağlamaz. |
| AUTH-16 | P0 | Davet üzerinden giriş | Süreli/tek kullanımlık davet, kayıt/giriş sonrası güvenli devam ve açık paylaşım kabulü. |
| AUTH-17 | P0 | Sağlayıcı kimlik iptali | Apple credential state/bildirim ve desteklenen sağlayıcı sinyallerini doğrulama; etkilenen oturum/yöntemi kapatma. |
| AUTH-18 | P0 | Hesabı uygulama içinden silme | Yeniden doğrulama, sonuç/etki özeti, token iptali ve Sportapp veri yaşam döngüsü; yalnızca deaktivasyon değildir. |
| AUTH-19 | P0 | Yetkili hesap koruması | Platform yöneticisinde MFA zorunlu; antrenörün hassas işlemlerinde step-up. Sosyal giriş tek başına MFA kanıtı sayılmaz. |
| AUTH-20 | P0 | Güvenli başlangıç ve hata durumları | Ağ kesintisi, SDK iptali, tekrarlı callback, eski uygulama oturumu ve yarım onboarding’den güvenli dönüş. |
| AUTH-21 | P1 | Passkey / ek hesap koruması | Olgun kimlik altyapısı üzerinden isteğe bağlı ek yöntem; biyometrik şablon Sportapp’a alınmaz. |
| AUTH-22 | P0 | Gerçek sağlayıcı yapılandırması | P0 iOS ve backend audience/client ID, entitlement, redirect, server secret ve ortam ayrımı; ayrı tarayıcı istemcisi yapılandırması P1; mock giriş üretimde açık kalmaz. |

### 2.2 Kimlik doğrulama, veri erişimi ve veri kullanımı ayrı şeylerdir

| Katman | Cevapladığı soru | Başarılı olunca ne olmaz? |
|---|---|---|
| **Sportapp kimliği** | Bu Sportapp hesabına kim giriş yapıyor? | Apple/Google ile giriş sağlık kaydı erişimi vermez. |
| **Kaynak erişimi** | Hangi uygulama/depodan hangi mevcut veri okunabilir? | Okuma izni AI’a veya antrenöre sınırsız paylaşım izni değildir. |
| **Sportapp işleme izni** | Okunan hangi veriler, hangi amaçla backend’de tutulup işlenebilir? | Veri başka hesapla, başka alıcıyla veya farklı amaçla kullanılamaz. |
| **AI paylaşımı** | Hangi alanlar hangi AI sağlayıcısına gidebilir? | API anahtarı veya oturum bu onayın yerine geçmez. |
| **Antrenör paylaşımı** | Hangi antrenör hangi kapsamı görebilir? | Antrenör rolü, davet linki veya ücret ödemesi tek başına erişim sağlamaz. |

Bu ayrım uygulama ekranlarında, API yollarında, veritabanında ve token kasasında korunur. Google, kimlik doğrulama için ID token doğrulamasını; Google API’lerine erişim için OAuth yetkilendirmesini ayrı tarif eder. [S25][S36]

**Örnek:** Kullanıcı Apple ile Sportapp’a girebilir, Apple Health’ten veri okuyabilir, seçtiği BYOK modelini kullanabilir ve Google ile giriş yapan antrenörüne sınırlı veri paylaşabilir. Aynı marka hesabını her katmanda kullanması gerekmez. Başka kişinin sağlık hesabını otomatik olarak kendi hesabıyla eşleştirme yapılmaz.

### 2.3 İlk açılış ve kayıt akışı

```text
Karşılama / ürün açıklaması / gizlilik bilgisine erişim
    ↓
E-posta ile kayıt/giriş  VEYA  Apple ile devam  VEYA  Google ile devam
    ↓
Sunucuda kimlik doğrulama + yeni/mevcut hesap ayrımı
    ↓
Yeni hesap: koşul kabulü + yetişkin hedef kitle uygunluğu + rol tercihi
    ↓
Kısa profil, hedefler, uygunluk ve ekipman
    ↓
“Verilerim hangi uygulamada?” → bağlantı / izin kurulumu VEYA “Şimdilik atla”
    ↓
İzinli ilk aktarım ve gözlenen kapsam özeti (bağlantı seçilmişse)
    ↓
Platform LLM / kendi AI bağlantım → alıcı ve veri paylaşım bilgilendirmesi
    ↓
Gerekli bağlam + geçerli işleme/AI izni → ilk haftalık taslak → kontrol → onay
```

Yeni kullanıcıdaki koşul kabulü, e-posta formunda veya sosyal doğrulama sonrasında kısa hesap tamamlama adımı olarak uygulanabilir. Dış sağlayıcı oturumunun başarıyla kurulması Sportapp sözleşmesinin kabul edildiği anlamına gelmez. Aydınlatma metnini sunma/kayda alma ile açık rıza gerektiren amaçları kabul ettirme ayrı tutulur; hukuki dayanaklar yayın öncesi doğrulanır.

E-posta hesabı `PROVISIONAL` başlayabilir; doğrulanana kadar yalnızca doğrulama, yardım, hesap tamamlama ve silme gibi sınırlı uçlara erişir. Sağlık içe aktarma, AI’a kişisel veri gönderme ve antrenörle paylaşım açılmaz. Apple/Google’ın sunucuda doğrulanmış kimliğiyle gelen kullanıcıya ayrıca yerel şifre kurdurulmaz. İletişim adresi doğrulama durumu kimlik doğrulama durumundan ayrı tutulur.

Sağlık uygulaması bağlama ve bildirim izni ilk planın zorunlu ön koşulu değildir. Kullanıcı manuel bağlamla ilerleyebilir. AI’a veri paylaşımını reddeden kullanıcı için hesaba/profiline/izinlerine ve mevcut planına erişim sürer; ilgili AI üretimi kapalı kalır. Bu ret, uydurma bir “tamamen yerel AI” seçeneği sunularak aşılmaz.

Antrenör olarak başlayan kullanıcıdan kendi Apple Health erişimi istenmez. Antrenör önce paneline ve açıkça kabul edilmiş sporcu ilişkilerine gider; kendisi için de sporcu modu açarsa kişisel sağlık akışı ayrı başlar. Davet linkiyle gelen kullanıcının hedef akışı giriş sonrasında korunur, ancak davet sağlık erişimini kendiliğinden açmaz.

Onboarding durumu sürümlü ve devam ettirilebilirdir. Kullanıcı uygulamayı kapatıp açınca bütün soruları tekrar cevaplamaz; yeni zorunlu bilgi varsa yalnızca ilgili bölüm sorulur.

### 2.4 Apple / Google giriş uygulama sözleşmesi

**Apple:** Native iOS’ta AuthenticationServices ve resmî Sign in with Apple düğmesi kullanılır. Tek kullanımlık giriş işlemi için rastgele nonce/state oluşturulur; sunucu kimlik token’ının imzasını, issuer/audience/süre ve ilgili nonce’ı doğrular. Kullanıcı eşleştirmesi doğrulanmış sağlayıcı kimliğine dayanır. İlk yetkilendirmede gelen ad/e-posta kaydedilir; sonraki girişte ad gelmemesi hata veya profili boşaltma nedeni değildir. Apple’ın private relay tercihi kabul edilir. Bu davranışlar Apple’ın kendi entegrasyon açıklamasında yer alır. [S23]

**P1 antrenör web’i eklendiğinde:** Apple native App ID ile antrenör web Services ID’nin kullanıcı eşleştirmesi resmî gruplama yapılandırmasına göre doğrulanır. Başka client ID’leri veya geliştirme ortamının audience’ını üretimde kabul eden genel bir wildcard doğrulama kullanılmaz. Authorization code değişimi ve gerekli token saklama/iptal akışı backend’dedir; Apple signing key veya client secret iOS paketine girmez.

Private relay adresine giden hesap e-postaları gerçek gönderici alanıyla test edilir; gönderici kaydı ve e-posta kimlik doğrulaması Apple’ın relay yapılandırmasına uygun yapılır. Kullanıcıya sırf kolaylık olsun diye gerçek e-postasını verme zorunluluğu konmaz. [S28]

**Google:** P0 iPhone uygulamasında resmî Google Sign-In SDK kullanılır. P1 antrenör web’i açılırsa uygun Google Identity Services akışı eklenir. Login kapsamı kimlik için gerekli bilgilerle sınırlıdır; aynı ekranda sağlık, takvim veya Drive yetkileri toplanmaz. Client/server kimlikleri ve dönüş URL’leri ortam bazlıdır. [S24]

Google ID token backend’de imza, issuer, audience, süre ve akışın gerektirdiği nonce/istemci kontrollerinden geçer. Düz `google_user_id`, e-posta veya yalnızca decode edilmiş JWT kimlik kanıtı değildir. Hesap anahtarı doğrulanmış `sub` olur; e-posta değişebilir. [S25][S26]

Native/OAuth akışlarında sağlayıcının desteklediği standart kütüphaneler ve sistem yetkilendirme oturumu kullanılır; kullanıcı sağlayıcı şifresini Sportapp formuna veya gömülü sahte login ekranına yazmaz. Authorization-code akışında native public client için PKCE uygulanır; protokol/sürüm desteği doğrulanmadan her sağlayıcıya aynı parametreler kopyalanmaz. [S33]

Her iki yöntemde giriş işlemi kimliği; amaç (`SIGN_IN`, `LINK_IDENTITY`, `STEP_UP`), hedef hesap, istemci ve kısa ömürle bağlanır. Yinelenen callback tek hesap/tek kimlik oluşturur. İptal edilen akış hata ekranına sıkıştırılmaz; kullanıcı diğer giriş yöntemini seçebilir. URL, analytics ve hata raporunda token veya authorization code tutulmaz.

### 2.5 Aynı hesaba farklı yöntemlerle giriş ve hesap çakışması

`User.id` uygulamanın değişmeyen iç kimliğidir. Apple/Google/e-posta kayıtları buna bağlanan ayrı `AuthIdentity` kayıtlarıdır. Sosyal kimlik benzersizliği doğrulanmış issuer/provider realm + subject üzerinden kurulur; client ve uygulama gruplaması ayrıca doğrulanır. E-posta ana sporcu kimliği değildir.

Kullanıcı ayarlardan yeni giriş yöntemi eklerken önce mevcut hesabını yeniden doğrular, ardından yeni Apple/Google kimliğini doğrular. Tamamlanmadan bağlantı yazılmaz. Yeni kimlik başka Sportapp kullanıcısına bağlıysa otomatik taşıma veya birleşme yapılmaz; sahiplik kanıtı gerektiren çakışma akışı açılır.

Aynı e-posta görüldü diye eski hesaba giriş izni verilmez. Dışarıya açık kayıt ekranı hangi yöntemlerin hangi e-postada bulunduğunu ifşa etmez. Güvenli doğrulama sonrasında “mevcut hesabına giriş yapıp bu yöntemi ekle” yönlendirmesi yapılabilir. Apple relay ve Google adresinin farklı olması olağandır; gerçek adres tahmin edilmez.

İki ayrı dolu hesabın bütün sağlık geçmişini birleştirme P0’da otomatik bir özellik değildir. P0’da veri kaybetmeden durdurma, doğru hesaba erişim ve güvenli destek/taşınabilirlik yolu bulunur. Gelecekte birleşme eklenecekse iki hesabın sahipliği, veri kökeni, antrenör izinleri ve yeni alıcı onayları ayrıca ele alınır.

Son kullanılabilir giriş yöntemi kaldırılmaz; alternatif yöntem eklenip doğrulanır veya kullanıcı açık hesap silme akışına yönelir. İletişim e-postasını değiştirmek, Apple/Google provider subject’ini değiştirmez. Sosyal-only hesaba genel “şifremi unuttum” akışından sessizce parola eklenmez.

### 2.6 E-posta, şifre ve kurtarma sözleşmesi

Yerel parola saklanacaksa olgun kimlik kütüphanesi/servisi tercih edilir; kendi kriptografi veya token sistemi icat edilmez. Şifreler argon2id gibi uygun parola hash mekanizmasıyla, sürümlü maliyet ve kullanıcı başına salt ile saklanır; tersine çevrilebilir şifreleme veya düz SHA ile tutulmaz. Yönetilen kimlik servisinin sağladığı eşdeğer güvenlik özellikleri ADR’de belgelenir. [S30]

Ürün parola politikası: MFA olmadan en az 15 karakter, en az 64 karakter kabul edebilen üst sınır; kesmeden doğrulama, parola yöneticisi/paste/AutoFill desteği, yaygın/ele geçirilmiş parola kontrolü. Keyfî periyodik parola değişimi veya zorunlu büyük harf/sembol kombinasyonu uygulanmaz. Hata ve kayıt/kurtarma yanıtları hesap varlığını açık etmez; oran sınırlama ve risk kontrolü kullanılır. [S29]

Doğrulama/sıfırlama token’ları kriptografik rastgele, amaç ve hesapla ilişkili, kısa ömürlü ve tek kullanımlıktır; sunucuda token’ın doğrulama özeti saklanır. GET ile link önizlemesi token’ı tüketmez veya hesabı değiştirmez; kullanıcı onayı sonrası işlem yapılır. Sıfırlama sonunda otomatik tam oturum açmak yerine yeniden giriş istenir; eski oturumlar iptal edilir ve güvenlik bildirimi gönderilir. [S31]

E-posta doğrulama, parola sıfırlama ve hesap bağlama token’ları birbirinin yerine geçmez. Yeni doğrulama gönderildiğinde eski linklerin davranışı açık kurala bağlanır. E-posta normalizasyonu gelişi güzel nokta/`+etiket` kaldırarak farklı adresleri birleştirmez. İletişim adresi değişiminde yeni adres doğrulanmadan eskisi silinmez.

### 2.7 Oturum, çıkış ve aynı telefonda hesap değiştirme

Sportapp, doğrulanmış sağlayıcı sonucundan kendi oturumunu üretir. Apple/Google kimlik token’ı, sağlık API erişim token’ı ve BYOK anahtarı Sportapp API bearer token’ı değildir. Sağlayıcı token’ları yalnızca ilgili adaptörde kullanılır.

Native istemci oturum sırları uygun iOS Keychain sınıfında; P0 admin web’inde ve gelecekteki P1 antrenör web’inde oturum Secure/HttpOnly ve uygun SameSite/CSRF korumalı cookie yapısında tutulur. Admin cookie/audience/kapsamı diğer istemcilerden ayrıdır; host sınırı geniş domain cookie ile gevşetilmez. Token’lar URL/localStorage’a konmaz. Kısa ömürlü erişim + dönen/iptal edilebilir refresh tasarımı veya eşdeğer sunucu oturumu kullanılır; tekrar kullanım ve oturum iptali test edilir. Süreler/yenileme yarışları ADR’de açıkça tanımlanır. [S32]

Çıkışta o iPhone’un Sportapp oturumu, hesap bazlı yerel sağlık cache’i, upload kuyruğu, AI geçici bağlamı ve push abonelik eşlemesi temizlenir/durdurulur. “Tüm oturumlardan çık” aynı User kimliğinin diğer iPhone ve varsa web admin oturumlarını, ayrıca açılmışsa P1 antrenör web oturumlarını da iptal eder. Yalnızca admin oturumunu kapatma ile tüm hesap oturumlarını iptal etme ayrı ve açık eylemlerdir. Bunlar hesabı ve sağlık kaynak kayıtlarını silmez.

**Çıkış ile bulut bağlantısı iptali farklıdır:** Bağımsız izinle önceden açılmış sunucu-sunucu kaynak/plan işleri için devam/durdur davranışı ayarlarda gösterilir; normal çıkış tüm sağlayıcı scope’larını körlemesine revoke etmez. “Bağlantıyı kes”, “arka plan işlemeyi durdur” ve “hesabı sil” ayrı eylemlerdir. Güvenlik nedeniyle hesabı kilitleme/ele geçirilme senaryosu ise ilgili sunucu işlerini de durdurabilir.

Aynı telefonda hesap A’dan çıkıp B’ye giriş yapıldığında yerel HealthKit OS izni Sportapp uygulaması için hâlâ mevcut olabilir. Bu, B hesabına o sağlık geçmişini yükleme yetkisi değildir. Yeni `LocalHealthBinding`, ilgili hesabın açık beyanı/işleme izni ve sunucu bağlama doğrulaması olmadan okuma-yükleme başlamaz. Önceki hesabın anchor’ı, batch’i, offline feedback’i, push hedefi veya planı B’ye taşınmaz. Logout öncesi başlayan geç callback’ler eski binding/session epoch nedeniyle reddedilir.

### 2.8 Yeniden doğrulama, sağlayıcı iptali ve hesap silme

Hassas işlemlerde kullanıcı aynı yöntemle yeniden doğrulanabilir veya hesabına bağlı başka geçerli yöntem kullanabilir. Elde edilen step-up grant hedef işleme, hesaba ve kısa süreye bağlıdır; hesap silme onayı AI paylaşım izni yerine kullanılamaz. Normal veri iznini kapatma işlemi gereksiz parola engeliyle zorlaştırılmaz.

Sağlayıcı iptal/bildirim olayları imza ve tekrar korumasıyla işlenir. Apple kimliğinin iptali etkilenen giriş yöntemini ve ilgili oturumları geçersiz kılar; sağlayıcı kimliği silindi diye başka geçerli giriş yöntemiyle bağlı Sportapp sağlık geçmişi sessizce silinmez. Hesap, bağlantı ve yasal silme yükümlülükleri farklı olaylar olarak değerlendirilir. [S23]

Hesap silme ayarlar içinde bulunabilir olmalı; sadece “hesabı dondur” veya destek e-postasına yönlendirme yeterli kabul edilmez. Apple ile oluşturulan hesaplarda gerekli sağlayıcı token iptali de yapılır. Apple, uygulama içinden silme başlatmayı ve Sign in with Apple token iptalini açıkça tarif eder. [S27]

Sportapp silme işlemi: kullanıcının açık onayı → `DELETION_PENDING` → yeni içe aktarım/AI/koç paylaşımı ve oturumların durdurulması → izin/bağlantı iptalleri → uygulama kayıtları, türevler, dosyalar, cache ve sırların saklama politikasına göre temizliği → sonuç bildirimi. Dış sağlayıcı revoke geçici hata verirse işlem sahte başarılı görünmez; tekrar kuyruğu ve açıklanmış durum tutulur. İptal tamamlanana kadar gerekli token yalnızca izole silme işi için erişilebilir kalır.

Apple Health/Google Health/Huawei Health/Samsung Health’teki özgün kayıtlar Sportapp tarafından silinmez. Yedek ve zorunlu saklama istisnaları açıklanır; minimal denetim izi bütün ham sağlık geçmişini sonsuza kadar saklama gerekçesi olmaz. Hesap silme sonrasında aynı sosyal kimlikle yeniden kayıt, silinmiş geçmişi otomatik geri yüklemez.

### 2.9 Geliştirici yapılandırması ve yayın kapısı

**v6 platform yorumu:** iOS login için backend’in kullandığı server/web-tipli OAuth client ID veya HTTPS callback tek başına bir web ürününü gerektirmez. Ancak bu sürümde özel admin web ürünü ve davetli personel login/MFA akışı açık P0 gereksinimidir. Tüketici/antrenör tarayıcı login arayüzü P1 kalır; native Apple/Google/e-posta gereksinimleri korunur. SDK ve dolaylı bağımlılıkların minimum iOS sürümü Bölüm 13.8’deki kapıdan geçer. [S24][S51]

D0/D1’de `AUTH_CONFIGURATION_MATRIX.md` hazırlanır: ortam, uygulama/platform, ilgili iOS bundle ID, Apple App ID/Services ID, Google iOS/web/server client ID, izinli callback/redirect, token issuer/audience, secret referansı, e-posta domaini ve sahiplik.

P0 Apple Developer capability/anahtarları ve private relay göndericisi; P1 antrenör web’i için ayrıca web domain/Services ID; Google Cloud OAuth istemcileri, uygulama markası/izin ekranı, gerektiğinde test kullanıcıları/doğrulama; P0 iOS URL dönüşü ve gerekiyorsa backend OAuth dönüş uçları; P1 antrenör tarayıcı istemcisi açıldığında onun callback’leri de uçtan uca doğrulanır. Native uygulamaya gizli client secret gömmek bir yapılandırma çözümü değildir.

Admin için P0 doğrulanmış e-posta hesabı + MFA ve davetli personel kaydı kullanılır; mevcut olgun kimlik hizmeti yeniden kullanılır. Sosyal-only hesaba sessizce parola eklenmez; mevcut hesabın güvenli yöntem bağlama akışı uygulanır. Admin sosyal/kurumsal SSO istenirse ayrı client/audience ve MFA kanıtıyla eklenir; iPhone’daki Apple/Google girişini kapatmaz. İlk platform sahibi bir defalık güvenli bootstrap/davet işlemiyle oluşturulur; genel kayıt veya sabit admin şifresiyle değil. [S56]

Apple/Google düğmeleri resmî bileşen ve marka kurallarına uygun, erişilebilir ve eşdeğer görünürlükte olur. P0’da ikisi de ürün gereksinimidir; uygulama yayını sırasında Apple’ın Login Services hükümleri ayrıca kontrol edilir. [S1][S24]

Mock auth yalnızca test ortamında ve gerçek sağlık verisi olmadan kullanılabilir. Gerçek sağlayıcı ayarları eksikse ilgili iş `BLOCKED_EXTERNAL` olarak raporlanır; herkese aynı kullanıcıyı veren bypass veya demo token üretime giremez. Mevcut auth sistemi varsa körlemesine değiştirilmez: gereksinim farkı, kimlik taşınması ve mevcut kullanıcıların hesapsız kalmaması için migration planı hazırlanır.

## 3. Ürün döngüsü ve planlama hiyerarşisi

**Kayıt/giriş + hesap tamamlama → Profil/hedef → İsteğe bağlı sağlık bağlantısı ve ayrı izinler → İzinli mevcut geçmişi içe alma → Hedef öncelikleri → Dönem stratejisi → Haftalık plan → Seans öncesi öneri → Antrenmanın dışarıda uygulanması/kaydedilmesi → Uygulama verisinin içe alınması + kısa geri bildirim → Uyarlama → Yeni hafta.**

### 3.1 Üç planlama katmanı

**Dönem stratejisi:** Yarış tarihleri, birincil/ikincil hedefler, hazırlık dönemleri, değerlendirme noktaları ve ana amaçlar. Bütün sezonun tekrarlarını ilk gün üretmez; uzak geleceği esnek tutar.

**Haftalık plan:** Günler ve zaman pencereleri, süreler, amaçlar, yoğunluk yönlendirmesi, ekipman, öncelik ve alternatifler. Haftaya ortadan başlayan kullanıcı için geçmiş günleri değil kalan günleri planlar.

**Günlük uyarlama:** Yeni içe aktarılmış kayıt veya kullanıcı talebiyle ilgili seansı ve gerekli sonraki seansları değiştirir. Her gün bağımsız bir program uydurmaz. Takvim haftasının değişmesi geçmiş yükü sıfırlamaz.

### 3.2 Antrenman günündeki deneyim

Kullanıcı önerilen seansın ayrıntısını Sportapp’ta görür. Antrenmanı alıştığı uygulama üzerinden kaydeder veya kendi düzeninde uygular. Sportapp’ta kayıt başlatması gerekmez. Yeni kayıt, desteklenen sağlık uygulaması yolundan geldiğinde planla eşleştirilir. Uygulama içe aktarımı beklerken isterse kullanıcı “yaptım/kısmen yaptım/yapmadım” ve zorluk beyanı verebilir.

Sportapp’ın seans ekranını açmak antrenmanın başladığı veya tamamlandığı anlamına gelmez. Bildirime basmak, ekranın açık kaldığı süre veya planlanan bitiş saati gerçekleşen antrenman kanıtı sayılmaz.

### 3.3 Başarı tanımı

Sağlık uygulaması bağlantısı olmayan kullanıcı gerekli manuel bağlamla ilk haftayı oluşturabilir; veri geldikçe plan zenginleşir. Ancak bağlantısız veya eksik veriyle verilen değerlendirme, tam veriyle doğrulanmış gibi sunulmaz.

Son onaylı plan ve gerekli seans açıklaması internet/model kesintisinde erişilebilir kalır. Güncel durumu bilmediğini açıklamak, eski öneriyi yeniymiş gibi sunmaktan önemlidir. “Canlı koç” ifadesi **yeni bilgi geldikçe yaşayan planı** anlatır; kesintisiz fizyolojik izleme iddiası değildir.

## 4. Önceliklendirme ve kaynak kapsamı

**P0:** İlk kullanılabilir sürümün kabul şartı. Altyapı veya mock tek başına tamamlanma değildir.  
**P1:** P0 doğrulandıktan sonra bağımsız entegrasyon ve iş akışı genişlemesi.  
**P2:** Ayrı ürün/teknik değerlendirme gerektiren ileri yetenek. Kapsam dışı ölçüm işlevleri P2 listesine taşınmaz.

**P0 çekirdeği:** iPhone 12 ve sonrası hedefli native iOS sporcu + antrenör deneyimi; e-posta/Apple/Google kayıt-giriş, hesap ve oturum yönetimi, ayrıştırılmış izin merkezi; aynı uygulamada temel antrenör çalışma alanı, salt okunur HealthKit, uygulama-kaynak ayrımı, Google Health/Huawei Health için Apple Health üzerinden yönlendirme ve kapsam görünümü, isteğe bağlı beyan, haftalık plan, günlük uyarlama, platform LLM’i, BYOK/özel endpoint, izinler, çevrimdışı plan ve güvenli veri yaşam döngüsü. **Web admin:** kayıtlı üyeler, üyelik/fiyat/ödeme takibi, minimum CRM, personel yetkileri ve denetim izi de P0’dır; aşağıdaki 9.1–9.10 kapsamına tabidir.

**P0 spor/içerik çekirdeği:** Geniş kaynak ve kanonik spor kataloğu; kas/örüntü/ekipman filtreleri; HIIT, fonksiyonel, Pilates dahil Bölüm 11.10’daki tipli planlama paketleri; branş deneyimi; çok sporlu hafta; kaynak sözlüğünün tam, sürümlü seed işlemi ve kapsam raporu. Diğer branşların katalog/manuel takvim katmanı P0; derin teknik koçluk yeteneği branş bazında doğrulanır. Katalog genişliği ile bütün branşlarda aynı uzmanlık iddiası birbirine karıştırılmaz.

**Önemli ayrım:** Google Health veya Huawei Health için ilk aşamada ayrı bir cihaz adaptörü yazılmaz. Apple Health’e aktarılan kayıtlar tek HealthKit okuyucusundan gelir; uygulama bazlı kurulum rehberi ve köken görünümü eklenir. Bu yolun veri türleri ve gerçek aktarım davranışı ayrı test edilir. [S12][S17]

**P1 kaynak işleri:** İhtiyaç ve onaylar doğrulanırsa Google Health hesap API’si, Huawei Health Kit bulut erişimi, diğer sağlık uygulamalarının resmî API’leri ve desteklenen uygulama dışa aktarım dosyaları. Bunlar ölçüm veya doğrudan donanım entegrasyonu değildir.

**Samsung kapısı:** iOS kaynağı için D0’da çözüm/eksik veri analizi yapılır. Doğrulanmış bir yol olmadan “Samsung Health bağlı” denmez. Android okuyucu/köprü gerekirse bu iOS uygulamasına gizlice eklenmez; ayrı kapsam kararı ve teslimat olur. Samsung’un tam veri erişiminin ilk yayına zorunlu olması istenirse bu karar, ayrıca doğrulanması gereken bir yayın bağımlılığıdır; varmış gibi kod yazılarak çözülemez.

### 4.1 Özellik listesi — iOS/iPhone ilk yayın ve uyumluluk

Bu gereksinimler mevcut fonksiyonları daraltmaz; hangi istemcide, hangi sürümlerde ve hangi test/dağıtım kanıtıyla teslim edileceklerini belirler. `P0`, yazılımın şu anda hazır olduğu anlamına gelmez.

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| IOS-01 | P0 | Native iPhone ilk yayın | P0 sporcu/antrenör aynı native uygulamada; Android/PWA/ayrı web UI bu teslimin yerine geçmez. P0 özel admin web paneli ayrı zorunlu teslimdir. |
| IOS-02 | P0 | iPhone 12 ailesi ve sonrası | 12 mini/12/12 Pro/12 Pro Max ve sonraki resmî model aileleri; bilinmeyen model numarası nedeniyle keyfî kilit yok. |
| IOS-03 | P0 | OS kapsam kararı ve tarihsel açık | İstenen geniş kapsam, iOS 14.x açık farkı ve önerilen 15.0 tabanı ayrı; IOS-SUPPORT-001 kapatılmadan tam kapsam iddiası yok. |
| IOS-04 | P0 | Tek sürümlü destek matrisi | Cihaz/OS/uygulama build/SDK/runtime/bağımlılık/kaynak sürümü ve test kanıtı; kurulamaz ve test edilmedi ayrıdır. |
| IOS-05 | P0 | Geriye uyumlu native katman | Swift/SwiftUI ve gereken UIKit uyumluluk bileşenleri; yeni API için availability kontrolü ve işlevsel alternatif. |
| IOS-06 | P0 | Bağımlılık tabanı denetimi | Doğrudan ve geçişli SDK minimumları pinlenir; güncelleme minimum OS’yi sessizce yükseltemez. |
| IOS-07 | P0 | Telefon ekranı ve erişilebilirlik | Mini ekran, büyük yazı, VoiceOver, klavye, yatay/dikey değişim ve güvenli alanlar; yalnızca büyük Pro ekranına göre tasarım yok. |
| IOS-08 | P0 | Native antrenör çalışma alanı | Sporcu listesi, katalog aramalı editör, brifing, onay, not ve davet iPhone’dan tamamlanır. |
| IOS-09 | P0 | Kaynak uygulama/OS yetenek ayrımı | Sportapp OS desteği ile dış uygulamanın kurulabilirliği/veri kategorisi ayrı; destek yoksa kontrollü açıklama ve devam. |
| IOS-10 | P0 | HealthKit sürüm kapıları | Yalnızca mevcut veri türleri için okuma talebi; olmayan enum/type için crash veya uydurma kayıt yok. |
| IOS-11 | P0 | Arka plan ve kilit davranışı | OS izin verdiğinde eşitle; kilit, düşük güç, force-quit ve background kısıtlarında veri güncelliğini doğru göster. |
| IOS-12 | P0 | Büyük ilk aktarım | Sayfalı/artan veri, cursor ve hesap/izin sürümü; kesilince kaldığı yerden sürdür, ana thread ve bellek yükünü sınırla. |
| IOS-13 | P0 | Yerel veri ve şema geçişi | Hesap bazlı korumalı cache, plan snapshot ve outbox; OS/uygulama yükseltmesinde kayıpsız migration. |
| IOS-14 | P0 | iPhone 12 performans kapısı | Açılış, liste/katalog, aktarım, bellek ve enerji profili gerçek alt cihazda; sunucu LLM gecikmesi ayrı ölçülür. |
| IOS-15 | P0 | Sunucu LLM ve BYOK sürekliliği | Apple Intelligence veya telefonda model çalıştırma şartı yok; app kapanınca job kimliğiyle güvenli geri dönüş. |
| IOS-16 | P0 | Native login ve dönüş rotaları | Apple/Google/e-posta, app link/deep link, cold/warm start ve auth bağlama; seçili OS kollarında gerçek test. |
| IOS-17 | P0 | iOS izin ve gizlilik paketi | Doğru entitlement/amaç metni/privacy manifest; read-only; gereksiz sensör/konum/Bluetooth izinleri yok. |
| IOS-18 | P0 | APNs ve hesap yaşam döngüsü | Bildirim reddinde çekirdek işler; token/kurulum/hesap eşlemesi ve logout/revoke; kilit ekranına hassas sağlık içeriği yok. |
| IOS-19 | P0 | Backend-eski istemci sözleşmesi | API/katalog/plan şeması sürümlü; bilinmeyen alanı kayıpsız ele al, gösterilemeyen önemli değişikliği onaylatma. |
| IOS-20 | P0 | Cihaz ve OS test altyapısı | Simulator, fiziksel test ve arşiv doğrulaması ayrı; olmayan runtime başarı sayılmaz, eski OS test runner’ı belgelenir. |
| IOS-21 | P0 | App Store dağıtım kontrolü | İmzalama, profil, arşiv, min OS, SDK, capability ve store metadata tutarlılığı; yalnızca derlenmesi yayın başarısı değil. |
| IOS-22 | P0 | Yeni iOS ve cihaz regresyonu | Her yeni kararlı OS/modelde smoke+çekirdek test; beta ayrı, gelecek sürümlere peşin garanti yok. |
| IOS-23 | P0 | Güncelleme ve destekten çıkarma | Sürüm tabanı değişikliği gerekçe/onay/bildirimle; hesap/silme/dışa aktarma yolu korunur, imkânsız update döngüsü yok. |
| IOS-24 | P0 | Uyumluluk izlenebilir teslimi | IOS_SUPPORT_MATRIX, IOS_DEPENDENCIES, IOS_TEST_PLAN, IOS_RELEASE_CHECKLIST ve açık kararlar gereksinim/teste bağlıdır. |

## 5. Özellik listesi — Profil, hedefler ve koşullar

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| PROF-01 | P0 | Kademeli başlangıç | Gerekli bilgilerle başlayabilir; her veri alanı zorunlu değildir. Neden istendiği açıklanır. |
| PROF-02 | P0 | Spor geçmişi | Antrenman yaşı ve son geçmiş; deneyim, ara verme, beceri ve içerik tercihleri branş bazında tutulur. Bir branşta ileri seviye olmak diğerinde ileri seviye sayılmaz. |
| PROF-03 | P0 | Kişisel bağlam | Yaş, gerektiğinde ilgili fizyolojik bağlam, tercih edilen dil ve birimler. Hassas alanlar amaçla sınırlı ve isteğe bağlıdır. Demografiden otomatik kapasite varsayılmaz. |
| PROF-04 | P0 | Kısıtlar | Kullanıcının bildirdiği rahatsızlık, kaçınmak istediği hareket, profesyonelce verilmiş kısıt ve güncellik bilgisi. Sistem teşhis uydurmaz. |
| PROF-05 | P0 | Performans profili | Branşa uygun performans/teknik referansları: kaynak uygulamadaki süre/mesafe/güç/yük kayıtları ve isteğe bağlı kullanıcı/antrenör değerlendirmeleri. VO₂max/nabız zorunlu değil; beceri, form veya mobilite ölçümü yapılmaz. |
| GOAL-01 | P0 | Çoklu hedef | Tek/çoklu branş; süre/yarış hedefi yanında düzen, kuvvet, kondisyon, mobilite, teknik ve ders devamlılığı. Örneğin Pilates + yüzme veya HIIT + kuvvet; HYROX/maraton yalnızca seçeneklerden bazılarıdır. |
| GOAL-02 | P0 | Hedef çatışması | Zaman/kapasiteyle uyumsuz hedeflerde açıklama ve seçenek; sessizce aşırı seans eklemek yok. |
| GOAL-03 | P0 | Hedef sürümleri | Hedef değiştiğinde ilgili gelecek planın etkisi önizlenir. Geçmiş hedefler silinmez. |
| GOAL-04 | P1 | Yarış standardı kataloğu | Yarış türü/kategori/yıl için doğrulanmış, sürümlü kurallar. Marka veya yarış adı tüm kategoriler için tek yük setine indirgenmez. |
| AVAIL-01 | P0 | Haftalık zaman pencereleri | Gün başına başlangıç/bitiş, toplam süre, iki seans olasılığı, dinlenme günleri, sabit etkinlikler. |
| AVAIL-02 | P0 | Tek seferlik istisnalar | Seyahat, bu hafta daha az gün, bugün 25 dakika, salon kapalı gibi geçici değişiklikler. |
| AVAIL-03 | P0 | Ekipman ve ortam | Salon/ev/dış mekân, mat/reformer/aparat, bant/serbest ağırlık/makine, kardiyo ekipmanı, havuz uzunluğu, kort/alan, partner ve tesis erişimi; ilgili sporun gerekli ayar ve yükleri. |
| AVAIL-04 | P0 | Süre hesabı | Isınma, çalışma, dinlenme, geçiş ve soğuma antrenman süresine dahildir. Kullanıcı ulaşım/duş bütçesini ayrıca tanımlayabilir. |
| AVAIL-05 | P1 | Takvim bağlantısı | Uygun izinle uygunluk okuma ve seçilen planı takvime yazma ayrı yeteneklerdir. Varsayılan olarak etkinlik başlıklarını LLM’e aktarma. |

**Eksik bilgi davranışı:** Güvenli ve uygulanabilir bir taslak için gereken bilgi yoksa kısa hedefli soru veya muhafazakâr başlangıç seçeneği sun. VO₂max, güncel nabız bölgeleri veya uyku verisi yok diye kullanıcıyı çıkmazda bırakma; bunları uydurarak devam da etme.

**Çok sporlu onboarding:** Kullanıcı ilgilendiği branşları, o branştaki deneyimini ve birincil/ikincil hedefini seçer; yalnızca ilgili ek sorular açılır. Pilates seçeneği “Other” altında gizlenmez. Koşucu olmayan kullanıcıdan koşu testi veya VO₂max istenmez. Kullanıcı sonradan yeni branş ekleyebilir; eski hedef/plan korunur ve değişikliğin haftaya etkisi önizlenir.

## 6. Özellik listesi — Sağlık uygulamalarından veri alma

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| DATA-01 | P0 | Apple Health / HealthKit salt okunur erişim | Gerekli ve mevcut aktivite/sağlık veri türleri için izinli okuma; ölçüm ve dış kaynağa yazma yok. |
| DATA-02 | P0 | İsteğe bağlı aktivite beyanı | Dış uygulamada kaydı bulunmayan çalışma için kullanıcı bildirimi; ayrı köken ve doğrulama durumu. |
| DATA-03 | P0 | Kısa günlük kontrol | Yorgunluk, bölgesel rahatsızlık, uyku algısı, stres ve zaman; sensör ölçümü değildir. |
| DATA-04 | P0 | Antrenman sonrası geri bildirim | İçe aktarılmış kayda veya planlı seansa bağlı zorluk, tam/kısmi durum ve neden. |
| DATA-05 | P0 | Beslenme bağlamı | Kaynak uygulamadan erişilebilen alınan enerji/makrolar ve isteğe bağlı açıklama; harcanan enerjiyle karıştırılmaz. |
| DATA-06 | P0 | Kayıt kökeni ve veri kalitesi | Yazıcı uygulama, erişim yolu, özgün kimlik/tanım/birim, zamanlar ve kullanım hakkı. |
| DATA-07 | P0 | Çift kayıt ve örtüşme yönetimi | Aynı aktivite/uyku/adım verisinin uygulamalar arasında kopyalanması toplamı çoğaltmaz. |
| DATA-08 | P0 | Plan-gerçekleşen eşleştirme | Bir-çok/çok-bir eşleşme, belirsizlik ve kullanıcı/antrenör düzeltmesi; yalnızca zaman benzerliğinden kesin eşleştirme yok. |
| DATA-09 | P0 | Kaynak güncelleme/silme işleme | Desteklenen değişiklik/silme sinyallerini yansıtma; uygulama kaynağa geri yazmaz. |
| DATA-10 | P0 | Eşitleme ve veri güncelliği | Son sorgu, son başarılı aktarım, son olay tarihi ve veri türü bazlı eksikler ayrı görünür. |
| DATA-11 | P1 | Resmî uygulama hesap API’leri | Google Health API/Huawei Health Kit gibi doğrulanmış API yolları; donanım protokolü yok. |
| DATA-12 | P1 | Uygulama dışa aktarımını içe alma | Açıkça desteklenen dosyalar; gerçek örnekle şema testi, kaynak ve kullanım hakkı kontrolü. |
| DATA-13 | P0 | Uygulama bağlantı kataloğu | Apple Health, Google Health, Huawei Health, Samsung Health için gerçek yol ve destek durumu; göstermelik bağlantı düğmesi yok. |
| DATA-14 | P0 | Uygulama/rota/veri türü yetenek matrisi | Okunabilir kategori, ayrıntı, geçmiş kapsamı, izin gözlenebilirliği ve AI/koç kullanım koşulları. |
| DATA-15 | P0 | İlk geçmiş aktarımı | İhtiyaç/izinle sınırlı tarih aralığı, sayfalama, devam etme ve kapsama raporu; bütün hayat geçmişini varsayılan çekme yok. |
| DATA-16 | P0 | Artımlı ve güvenli eşitleme | Kaynak kimlikleriyle idempotency; cursor/anchor kaybında kontrollü yeniden okuma; rate limit ve hata yönetimi. |
| DATA-17 | P0 | Köprü kurulum rehberi | Google Health/Huawei Health → Apple Health → Sportapp izin ve paylaşım adımlarını kaynak uygulama sürümüne uygun açıklama. |
| DATA-18 | P0 | Kaynak önceliği ve çatışma görünümü | Veri türüne göre kaynak seçimi; alternatif kayıtlar korunur, farklı değerler körlemesine ortalanmaz. |
| DATA-19 | P0 | Kayıt gelmedi akışı | Beklenen antrenman için `AWAITING_DATA`; izin/aktarım/gecikme kontrolü ve isteğe bağlı kullanıcı teyidi. |
| DATA-20 | P0 | Salt okunur sınırın denetimi | Sağlık deposuna write/delete scope, sensör izni, kayıt oturumu ve cihaz eşleştirme akışı yok. |
| DATA-21 | P0 | Bağlantı kesme ve kapsam azaltma | Yeni okuma/gönderimleri durdurma, geçmişi koruma/silme seçenekleri ve etkilerin açıklanması. |
| DATA-22 | P1 | Samsung erişim çözümü | Doğrulanmış uygulama köprüsü/API; gerekirse ayrı onaylı Android okuyucu. Destek yoksa açık `UNSUPPORTED_ON_IOS`/`NEEDS_VERIFICATION`. |
| DATA-23 | P0 | Kaynağa gidemeyen ayrıntıyı yönetme | Uygulamada görünen fakat API/HealthKit’e yazılmayan alanları bilinmiyor sayma; ekran okuma veya gizli API ile aşma yok. |

### 6.1 Erişim yolları: uygulama ile teknik arayüz aynı şey değildir

| Kullanıcının veri tuttuğu uygulama | Sportapp iOS için yol | Sınır ve ürün kararı | Belgesel dayanak |
|---|---|---|---|
| **Apple Health** | iOS içindeki HealthKit deposundan kullanıcı izinli okuma | P0. Telefon içindeki native okuyucu, izinli veriyi kendi backend’ine iletir. Apple hesabına bağlanan hayalî bir genel sunucu API’si yazma. | [S4] |
| **Google Health** | Uygulamanın Apple Health’e paylaştığı kayıtları HealthKit’ten okumak | P0 köprü yolu. Paylaşım yönü ve veri türü bazlı sınırlar vardır; Google Health’te görülen her gösterge dışarı çıkmaz. | [S12] |
| **Google Health hesabı** | Resmî Google Health API ile kullanıcı yetkilendirmeli bulut erişimi | P1 alternatif. API izin/erişim, gerçek kapsam ve veri kullanım koşulları doğrulanır. Bu bir uygulama hesabı entegrasyonudur. | [S13][S21] |
| **Huawei Health** | iOS uygulamasının Apple Health/HealthKit’e aktardığı kayıtları okumak | P0 köprü yolu. Bölge, uygulama varyantı, veri türü ve kurulum bazında gerçek kapsam test edilir; tam uyku/nabız/VO₂max garantisi yok. | [S17] |
| **Huawei Health hesabı** | Health Kit bulut/REST erişimini değerlendirmek | P1 aday. Resmî belgeler REST yolunu tarif eder; bu proje için geliştirici onayı, hesap bölgesi ve endpoint kapsamı henüz test edilmemiştir. | [S18] |
| **Samsung Health** | iOS için genel doğrudan veri okuma yolu bu incelemede doğrulanamadı | Resmî Data SDK Android’e yöneliktir. iOS uygulamasının bulunması tam dışa aktarım API’si bulunduğu anlamına gelmez. | [S14][S19] |
| **Samsung Health → Health Connect** | Android üzerindeki izinli uygulamalar arası veri paylaşımı | Android için resmî yol; iPhone backend’i Android’in yerel deposunu uzaktan okuyamaz. iOS’a devam eden zincir ayrıca doğrulanmalıdır. | [S15][S16] |
| **Diğer sağlık/fitness uygulamaları** | Apple Health’e paylaştıkları veri veya resmî hesap API’si | Uygulama ve veri türü bazlı eklenir. “Tüm uygulamalar desteklenir” vaadi yok. | Sağlayıcı bazında doğrulama |

**Doğrulama seviyesi:** Tablo dış platform belgelerinde bulunan yolları gösterir; bu dosya hazırlanırken Sportapp kodu, canlı kullanıcı hesabı veya kaynak uygulama bağlantısı üzerinde entegrasyon testi yapılmamıştır. “P0/P1” geliştirme önceliğidir; “hazır” durumu değildir.

**Google isimleri:** Google Health uygulaması ve Google Health API, Android’in Health Connect deposundan farklıdır. Google Fit eski entegrasyon yüzeyiyle, Cloud Healthcare API ise farklı bir sağlık veri hizmetiyle ilgilidir. Yeni geliştirmede “Google Health” adını otomatik olarak Google Fit veya Health Connect’e çevirme. Google’ın güncel geçiş rehberi yeni entegrasyonlar için Health Connect/Google Health API yollarını ayırır. [S13][S16][S22]

**Somut yön farkı örneği:** Google’ın güncel Apple Health tablosunda HRV, Google Health’in Apple Health’ten okuyabildiği alanlar arasında yer alırken ters yöndeki yazma listesinde yer almıyor. Bu nedenle Google Health ekranında bir metrik görmek, Sportapp’ın HealthKit yoluyla o metriği alabileceğinin kanıtı değildir. [S12]

**Samsung için yanlış çıkarım:** iOS mağaza açıklamasında Apple Health’in adım bilgisinin Samsung Health’e paylaşılması anlatılıyor. Bu, Samsung Health’in bütün sağlık verilerini Apple Health’e yazdığını göstermez. Samsung → başka uygulama → Apple Health zinciri ancak her aktarım yönü, veri türü, bölge ve kullanıcı hesabıyla uçtan uca test edilirse destek olarak sayılır. [S19]

### 6.2 Önerilen veri akışı

```text
Apple Health / HealthKit’te mevcut kayıtlar ───────────────────┐
Google Health ── izinli paylaşım ──> Apple Health ─────────────┤
Huawei Health ── izinli paylaşım ──> Apple Health ─────────────┤
                                                            v
                                             Sportapp iOS salt okunur okuyucu
                                                            |
                                          İzinli ve amaçla sınırlı aktarım
                                                            v
                              Kaynak defteri → Birleştirme → Sporcu geçmişi
                                                            |
                                Hedefler + uygunluk + kısa kullanıcı beyanı
                                                            v
                                   Plan/uyarlama motoru ↔ seçilmiş LLM
                                                            |
                                            Sporcu / antrenör onayı
                                                            v
                                          Haftalık plan ve günlük öneri

P1: Resmî uygulama hesap API’si → backend kaynak adaptörü → aynı veri defteri
Samsung: Yalnızca doğrulanmış yol devreye alınır; diyagramdaki köprü varsayılmaz.
```

Her dış uygulama için ayrı “saat bağla” akışı kurulmaz. HealthKit üzerinden okunan iki uygulama için iki fiziksel bağlantı açılmaz; tek erişim kanalı üzerinde kaynak kayıtları ayrılır.

### 6.3 Salt okunur HealthKit sözleşmesi

Yalnızca gereken veri türlerine read izni iste; share/write türleri boş olsun. `HKHealthStore` sorguları, uygun observer/anchored sorgular ve gerekli okuma yetenekleri kullanılır. Workout session/builder, sensör başlatma, konumla ölçüm ve sağlık deposuna kayıt yazma yoluna girilmez. [S4]

HealthKit okuma izninin reddini her durumda doğrudan açıklamaz. `authorizationStatus` gibi yazma paylaşım durumunu ifade eden sonuçlar “tüm veriyi okuma yetkim var” göstergesi yapılmaz. Veri yokluğu; izin kısıtı, veri bulunmaması veya henüz aktarılmamış olma gibi nedenlere bağlı olabilir. Arayüz gerekli yerde `UNKNOWN` kullanmalıdır. [S2]

Arka plan bildirimi “hangi verinin değiştiğini ayrıca sorgula” tetikleyicisidir; canlı sensör akışı veya tam saatte çalıştırma garantisi değildir. Kaynak uygulamanın henüz yazmadığı veri HealthKit okuyucusunu daha sık çalıştırarak elde edilemez. [S3]

Plan, geri bildirim ve analiz Sportapp’ın deposunda tutulur. Kullanıcı “yaptım” işaretledi diye HealthKit’e yeni workout yazılmaz. Kaynak kaydındaki hatalar Sportapp’ta açıklama/ayrı düzeltme beyanı olarak tutulabilir; orijinal kaydı değiştirme yetkisi istenmez.

### 6.4 Veri türü bazlı kapsam

| Veri | Alınacak ayrıntı — mevcut ve izinli olduğunda | Eksik olduğunda davranış |
|---|---|---|
| Antrenman | Kaynak ID, tür, başlangıç/bitiş, süre, mesafe, mevcut özet/segmentler | Plan tamamlandı varsayma; kullanıcı beyanını ayrı tut. |
| Nabız | Kaynağın sunduğu zaman serisi veya özet ve kayıt aralığı | Gün boyu örnekleri otomatik antrenman nabzı sayma; canlı değer gösterme. |
| HRV / dinlenik nabız | Metrik tanımı, tarih, birim, kaynak, varsa ölçüm bağlamı | Farklı HRV tanımlarını tek seri yapma; yoksa sıfır yazma. |
| Uyku | Oturumlar, süreler, varsa evreler ve kayıt zamanı | Toplam süre evre verisi değildir; bütün uygulamalar evre paylaşır varsayma. |
| VO₂max / kapasite referansı | Kaynak uygulamadaki değer, tarih, yöntem/etiket mevcutsa | Sportapp ölçmez; zorunlu alan olmaz; uydurulmaz. |
| Kuvvet / hibrit | Gerçekten aktarılan set/tekrar/yük/istasyon ayrıntısı | “Kuvvet, 45 dakika” kaydından set/tekrar icat etme; isteğe bağlı beyan iste. |
| Enerji / beslenme | Alınan enerji, aktif/bazal/toplam harcama ve makroları ayrı tut | Eksik beslenme sıfır tüketim değildir; kesin günlük enerji açığı üretme. |
| Günlük hareket / vücut değerleri | Kararla ilişkili, mevcut adım/hareket/vücut kayıtları | Antrenmanla çift sayma; amaç dışı geniş sağlık kaydı isteme. |

Tüm bu veri türleri her kaynak yolunda mevcut değildir. Tablonun anlamı “desteklenirse nasıl işlenecek?”tir; üreticiler için eşit kapsam garantisi değildir. Klinik kayıtlar, tam konum rotası ve kararla ilişkili olmayan hassas kategoriler P0 veri talebine dahil edilmez.

**Branş/hareket ayrıntısı:** Kaynakta spor adı, toplam süre ve nabız özeti varsa sadece bu ayrıntı bilinir. Hareket adı, set, tekrar, ağırlık, yüzme stili, Pilates aparatı veya teknik değerlendirme aktarılmıyorsa `not_provided` olarak kalır. Katalogda karşılık olması kaydın o hareketleri içerdiği anlamına gelmez. Tür bazlı detay kapsamı her aktarım yolunda ayrıca test edilir; Garmin referans kataloğu yeni bir sağlık veri bağlantısı değildir.

### 6.5 Kaynak, geçerlilik ve güncellik modeli

Her kayıtta en az şu mantıksal alanlar yer almalıdır:

`athlete_id`, `connection_id`, `access_route`, `writer_app_id`, `origin_app_id_if_known`, `source_record_id`, `source_record_version_if_available`, `data_type`, `record_kind`, `event_start`, `event_end`, `original_timezone_or_offset`, `source_updated_at_if_available`, `first_seen_at`, `ingested_at`, `unit`, `value_or_summary`, `granularity`, `provenance_refs`, `rights_policy_ref`, `consent_version`, `quality_flags`.

`record_kind`: `IMPORTED_OBSERVATION`, `SOURCE_ESTIMATE`, `USER_REPORTED`. Değerin niteliği ayrıca `value_nature = MEASURED | ESTIMATED | REPORTED | UNKNOWN` olarak saklanır. Sportapp analizleri bu ham kayıt türlerine yazılmaz; ayrı `DerivedFeature` varlığında tutulur. Kaynak değerin doğrudan ölçüm mü tahmin mi olduğunu söylemiyorsa `value_nature = UNKNOWN` korunur.

**Yazıcı uygulama ile erişim yolu ayrı:** “Huawei Health → Apple Health → Sportapp” yolunda HealthKit erişim kanalı, Huawei ise belgelenebildiği ölçüde kaynak uygulamadır. Orijinal uygulama zinciri aktarımda kaybolmuşsa kayıp alanları uydurma. Kaynakta cihaz açıklaması bulunursa yalnızca isteğe bağlı köken metadatasıdır; Sportapp’ın cihaza bağlandığı anlamına gelmez.

**Güncellik alanları ayrı:** “Az önce sorgulandı”, “az önce veri aktarıldı” ve “en son antrenman dün gece” farklıdır. Yeni kayıt dönmeyen başarılı sorgu eski uyku kaydını yeni yapmaz. Kaynak uygulamanın en son eşitleme zamanı bilinmiyorsa gösterilmez.

Her `ConnectionCapability` kaydı; uygulama/yol/veri türü, yön, ayrıntı düzeyi, bölge/sürüm, izin talep durumu, izin gözlenebilirliği, gözlenen tarih kapsamı, değişiklik/silme desteği, AI ve antrenör kullanım hakkı, test tarihi ve kanıt durumunu içerir. Teknik destek, kullanıcıda veri bulunması ve kullanım izni ayrı boyutlardır.

### 6.6 Eşitleme, tekrar ve silme davranışı

İlk okuma amaçla sınırlı tarih aralığından, sayfalı ve devam ettirilebilir biçimde yapılır. Geçmiş kapsamı kullanıcıya raporlanır. Yakın döneme ait yeterli veri gelmeden tüm geçmiş tamamlandı gibi görünmez; gerekirse sınırlı bağlamla açık varsayımlı plan önerilir.

Observer/webhook mevcutsa değişiklik tetikler; yeni kayıtlar ardından yetkili sorguyla alınır. Webhook her kayıtta vardır varsayılmaz. Uygulama açılışı ve kullanıcının yenileme isteği ayrıca tetikleyicidir. Backend’in iPhone’daki HealthKit’i her dakika doğrudan sorguladığı mimari kurulmaz.

Cursor/anchor; hesap, yerel HealthKit deposu/uygulama kurulumu, veri türü ve kapsamla ilişkilendirilir. Kalıcı olarak kabul edilmeyen batch için cursor ilerletilmez. Yeniden kurulum/telefon değişimi/çökme sonrası tekrar okuma çift kayıt yaratmamalıdır. Aynı telefonda başka Sportapp hesabına geçmek, o telefonun sağlık geçmişini yeni hesaba otomatik aktarmamalıdır; açık bağlama/onay gerekir.

Kaynağın verdiği düzeltme/silme olayları işlenir. Ancak her köprü silmeyi sonraki uygulamaya taşımayabilir: kaynağın özelliği yoksa otomatik tam silme yayılımı vaat etme. Periyodik uzlaştırma ve kullanıcı düzeltme/silme akışı tasarla. Erişim iptali nedeniyle görünmeyen kayıtlar otomatik olarak “kaynakta silinmiş” sayılmaz.

İzinli bulut hesap API’lerinde OAuth token yenileme/iptal, rate limit, 429 yanıtı, sayfalama ve webhook doğrulaması kaynak adaptörünün işidir. Sağlık hesabı token’ı AI anahtarından ayrı kasada/kapsamda tutulur; LLM’e verilmez.

### 6.7 Çift kayıt, uzlaştırma ve plan eşleştirme

Ham kaynak kayıtları korunur; analiz için kanonik aktivite/uyku kayıtları oluşturulur. Güçlü kimlik varsa önce kullanılır; yoksa tür, zaman, süre, mesafe ve kaynak zinciriyle açıklanabilir eşleşme yapılır. Yakın zamanlı iki gerçek seans yanlışlıkla birleştirilmez. Şüpheli eşleşme işaretlenir; kullanıcı/antrenör ayırabilir.

Günlük adımların, uyku aralıklarının veya günlük toplam kaloriyle antrenman kalorilerinin körlemesine toplanması yasaktır. Aynı metriği iki yoldan okuma iki bağımsız fizyolojik kanıt değildir. Kaynak önceliği/örtüşme politikası metrik bazında tanımlanır; sessiz “ortalama al” çözümü kullanılmaz.

Manuel “yaptım” beyanı ile daha sonra gelen dış uygulama kaydı aynı aktivitede ilişkilendirilir; toplam yük iki kez sayılmaz. Farklar saklanır; kullanıcı beyanı ölçülmüş kaydı iz bırakmadan ezmez.

Planlı seans yalnızca tarih/tür benzerliğiyle kesin tamamlanmış sayılmaz. Bir hibrit seans birkaç ayrı kayda bölünebilir, bir kayıtta birden fazla plan bloğu bulunabilir. Eşleşme kanıtı ve güveni görünür olmalıdır.

**Tür eşleme sözleşmesi:** Kaynak uygulama adı/kodu, kaynak sürümü, kanonik branş/varyant, yöntem, eşleme sürümü ve `EXACT / BROADER / NARROWER / AMBIGUOUS / CUSTOM / UNMAPPED` ilişkisi korunur. `NARROWER` yalnızca ek kaynak kanıtı veya ayrı kullanıcı beyanıyla kullanılabilir; generic kayıttan detay uydurulmaz. Kullanıcı düzeltmesi orijinal kaydı değiştirmez. Karışık seansın ana kaydı/alt segmentleri ayrı aktiviteler gibi çift sayılmaz. Plan eşlemesi spor, zaman, süre ve bağlamla yapılır; planlanan hareket listesi gerçekleşen kayda otomatik kopyalanmaz.

### 6.8 Kaynak kullanım hakkı, AI ve antrenör erişimi

Sağlık uygulamasının erişim koşulları, kullanıcının izni, AI sağlayıcı paylaşımı ve antrenör görünürlüğü birlikte değerlendirilir. Köprü veya özet kullanmak uygulanabilir kaynak koşullarını otomatik kaldırmaz.

Örneğin Strava API’si üzerinden edinilmiş verinin AI/context kullanımına ilişkin güncel kısıtları vardır; bu yoldan gelen veri veya türevi, izin hakkı yokken başka bir depo üzerinden yeniden etiketlenerek AI’a verilmez. Buna karşılık sadece bir kayıt adında “Strava” geçmesi, API sözleşmesinin her bağımsız veri yoluna otomatik uygulanacağını kanıtlamaz; edinim yolu ve uygulanabilir koşullar değerlendirilir. [S9]

Google Health API hesabı için de o API’nin geliştirici/kullanıcı verisi politikaları ayrıca uygulanır. API’ye erişebilmek, her alıcıya sınırsız AI aktarımı anlamına gelmez. [S21]

İzinli ve ilgili veri filtresi **LLM öncesinde** uygulanır. Sağlayıcı anahtarı, OAuth token, tüm ham sağlık geçmişi ve amaç dışı klinik veriler prompt içine konulmaz. Antrenöre kapalı veri, onu ele veren açıklama veya türetilmiş özet yoluyla sızdırılmaz.

### 6.9 Bağlantı ekranının doğru davranışı

Arayüz “Hangi saati kullanıyorsun?” yerine **“Antrenman ve sağlık verilerin hangi uygulamada?”** diye sorar. Donanım modeli zorunlu alan değildir. Kaynak uygulama seçimi, aktarım yolunu ve veri kapsamını gösterir.

Bağlantı durumu örnekleri: `AVAILABLE_NOT_CONNECTED`, `SETUP_REQUIRED`, `RELAY_CONFIGURATION_REQUIRED`, `ACTIVE_DATA_OBSERVED`, `CONNECTED_NO_DATA_OBSERVED`, `PARTIAL_COVERAGE`, `STALE`, `REAUTH_REQUIRED`, `PAUSED_BY_USER`, `BLOCKED_EXTERNAL`, `UNSUPPORTED_ON_IOS`, `NEEDS_VERIFICATION`.

HealthKit’te kesin gözlenemeyen izin durumları için sahte `GRANTED/DENIED` gösterme. “İstek tamamlandı” ile “gerekli kayıtları okuyabildik” ayrı olsun. Tüm uygulamalar kurulu varsayma veya kullanıcının telefonundaki bütün uygulamaları tarayan bir özellik ekleme.

Kaynak uygulama içinden Apple Health paylaşımını açma ve Sportapp’a okuma izni verme iki ayrı adımdır. Bunlardan biri eksikse sorunun nerede olabileceği açıklanır; kullanıcıya yeni cihaz alması söylenmez. Kaynak uygulamayı açma bağlantısı ancak belgeli/deep-link desteği doğrulanmışsa eklenir.

### 6.10 Özellik listesi — İzin alma ve izin merkezi

İzinler yalnızca bir onboarding ekranı değildir: kullanıcı niyeti, OS/sağlayıcı yetkisi, Sportapp işleme sınırı ve veri çıkış kontrolleri birlikte çalışan bir yaşam döngüsüdür. Mevcut DATA-01, DATA-14, DATA-17 ve DATA-21 gereksinimleri korunur; aşağıdaki özellikler bunların hesap/izin uygulamasını somutlaştırır.

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| CONSENT-01 | P0 | Bağımsız izin merkezi | Giriş yöntemleri, veri kaynakları, Sportapp işleme, AI alıcıları, koç paylaşımı ve bildirim ayarları ayrı görünür. |
| CONSENT-02 | P0 | Bağlamında açıklama ve izin | Hangi veri, neden, nereye, hangi süreyle; işletim sistemi penceresinden önce açıklama ve atlama seçeneği. |
| CONSENT-03 | P0 | Veri türü bazlı kapsam | Antrenman, nabız, uyku, HRV, beslenme gibi gruplar ayrı; ihtiyaç dışı “tüm sağlık verileri” isteği yok. |
| CONSENT-04 | P0 | Native HealthKit okuma talebi | Yalnızca gerekli read türleri, `toShare` boş; HealthKit desteği/amaç metni ve gerçek iPhone testi. |
| CONSENT-05 | P0 | Köprü için iki ayrı izin adımı | Kaynak uygulamanın Apple Health’e yazması ve Sportapp’ın oradan okuması ayrı kontrol/rehberdir. |
| CONSENT-06 | P0 | Kısmi/ret/belirsiz izin davranışı | İzin verilmeyen veya görünmeyen veride manuel/sınırlı plan; sağlık izni olmadan hesap kullanılabilir. |
| CONSENT-07 | P0 | İlk aktarım öncesi sunucu işleme | Kimlik, hesabın yerel sağlık bağlaması, kategori/tarih aralığı ve geçerli işleme izni kontrol edilir. |
| CONSENT-08 | P0 | Kaynak ve kapsam daraltma | Yeni read/upload durur; ilgili türev, AI, öneri ve koç görünürlüğünün etkisi açıklanır. |
| CONSENT-09 | P0 | İzin geri çekme | Backend, native okuyucu, cache ve kuyruklar güncellenir; OS izni uygulamadan kapatılmış gibi gösterilmez. |
| CONSENT-10 | P0 | AI alıcı onayı | Platform LLM ve BYOK/custom endpoint için gerçek alıcı, amaç ve veri kategorileri; sessiz fallback yok. |
| CONSENT-11 | P0 | Antrenör paylaşım onayı | Antrenör/organizasyon kimliği, alan kapsamı, tarih aralığı/süre; sporcu onayı ve geri çekme. |
| CONSENT-12 | P0 | Sürümlü izin kaydı | Metin sürümü, alıcı, amaç, kategori, kapsam, karar zamanı ve geri çekme; sır/ham sağlık verisi kayda gömülmez. |
| CONSENT-13 | P0 | Kuyruk ve veri çıkışı kontrolü | Görev başlatmada, aktarım/yayın öncesinde güncel izin; eski izin sürümüyle kaçak gönderim yok. |
| CONSENT-14 | P0 | Yeniden bağlanma ve yeni kategori | Güncel kapsam önizlenir; eski izin bütün yeni veri türlerini otomatik açmaz. |
| CONSENT-15 | P0 | Destek durumuna uygun izin ekranı | iOS yolu yoksa sahte OAuth/OS penceresi ve “başarıyla bağlandı” yok; gerçek destek kanıtı gösterilir. |
| CONSENT-16 | P0 | Aynı telefonda hesap izolasyonu | HealthKit OS izni hesaplar arasında Sportapp veri işleme izni olarak miras kalmaz. |
| CONSENT-17 | P0 | Hesap API’si yetkilendirme altyapısı | Ayrı token kasası/bağlantı/izin modeli; gerçek Google/Huawei bağlayıcısı kendi P1 önceliğinde kalır. |
| CONSENT-18 | P0 | Bildirim ve diğer isteğe bağlı izinler | Bildirim, P1 takvim ve pazarlama ayrı; sağlık bağlantısına veya sosyal girişe bağlanmaz. |

### 6.11 Kullanıcıdan ne zaman hangi izin alınacak?

| Aşama | Gösterilen bilgi / izin | Reddedilirse |
|---|---|---|
| Kayıt/giriş | Sportapp koşulları, gizlilik aydınlatması; Apple/Google temel kimlik akışı | Alternatif giriş yöntemi veya çıkış; kaynak sağlık şifresi istenmez. |
| Sağlık verisi bağlantısını seçme | Kaynak, erişim yolu, kategori, amaç, seçili geçmiş aralığı ve Sportapp backend’ine aktarım | Kaynak bağlanmadan hedef/uygunluk ve manuel beyanla devam. |
| Apple Health bağlantısını açma | Sportapp’ın HealthKit okuma talebi için gerçek iOS izin ekranı | Kısmi/bilinmeyen kapsam; tüm alanları verilmiş gösterme yok. |
| Google/Huawei köprü kurulumu | Kaynak uygulamada Apple Health’e paylaşım yönlendirmesi; sonra Sportapp HealthKit izni | Köprü eksikliği açıklanır, diğer veri kaynakları korunur. |
| İlk AI kişiselleştirme | Seçilen AI servisi, veri alanları ve kullanım amacı | O AI görevi kapalı; mevcut hesap/plan ve manuel yönetim açık. |
| Antrenör ekleme | Kim görecek, hangi verileri, hangi dönem ve süreyle? | İlişki kabul edilmez veya daha dar kapsam; otomatik geçmiş ifşası yok. |
| Bildirim açma | Hatırlatma/onay bildiriminin amacı, OS bildirim izni | Uygulama içinde ilgili bilgi görünür; plan üretimi engellenmez. |
| Sonradan kategori/alıcı ekleme | Yeni veri veya alıcı için fark/onay | Önceki geçerli kapsam değişmeden kalır. |

Bildirimler varsayılan kilit ekranında hassas sağlık ayrıntısı taşımaz. Pazarlama izni önceden seçili değildir; spor planına erişimin koşulu yapılamaz. Takvim P1’de eklenirse kendi OS/API yetkisi ve amaç açıklamasıyla açılır.

**İzin merkezindeki örnek kartlar:** “Apple/Google ile giriş”, “Apple Health’ten okunan kayıtlar”, “Sportapp sunucusunda işleme”, “AI ile paylaşılan veriler”, “Antrenör erişimleri”, “Bildirimler”. Aynı marka için login kartı ile sağlık verisi kartı ayrı olur. Her kartta mevcut kapsam, son değişiklik, ilgili açıklama ve yönetim eylemi bulunur.

### 6.12 HealthKit izin akışı — salt okunur ve gerçekçi

HealthKit izni iPhone’daki native Sportapp istemcisinde istenir; backend veya antrenörün web tarayıcısı iPhone için bu pencereyi açıp izin veremez. Gerekli HealthKit capability ve kullanıcıya amacını açıklayan `NSHealthShareUsageDescription` tanımlanır. Okuma için gerekli veri türleri seçilir; `requestAuthorization(toShare: [], read: selectedReadTypes)` anlamındaki salt okunur sözleşme korunur. [S34][S35]

**Uygulama sırası:** Kullanıcı bağlanmayı seçer → minimum tür ve amaç açıklaması → Sportapp sunucu işleme/hesap bağlama onayı → gerçek OS talebi → sınırlı tarih aralığında okuma → izinli kategorileri/kaynakları yerelde filtreleme → backend kapsam kontrolü → gözlenen verinin özeti.

`requestAuthorization` işleminin başarılı tamamlanması, bütün okuma izinlerinin verildiğini kanıtlamaz. `authorizationStatus(for:)` yazma/paylaşım durumunu anlatır; okuma için genel bir `GRANTED` makinesi kurulmaz. Sağlık gizliliği nedeniyle görünmeyen kaydın sebebi izin reddi mi yokluk mu her zaman bilinemez. [S2][S34][S35]

Bu nedenle dört durum boyutu ayrı tutulur:

- **Kullanıcının Sportapp tercihi:** kategori/amaç/alıcı açık, kapalı veya henüz seçilmedi.
- **OS talebi:** istenmedi, gösterilmesi talep edildi, tamamlandı, hata veya OS koşulu nedeniyle kullanılamıyor.
- **Gözlenen kapsam:** veri görüldü, kısmi, eski, görünür veri yok.
- **Kaynak desteği:** teknik olarak destekli, eksik, doğrulanmamış veya iOS’ta desteklenmiyor.

Okuma izni kapalıysa her açılışta tekrar pencereyle baskı yapılmaz. Kullanıcı kendi isteğiyle “İzinleri yönet” derse güncel iOS sürümüne uygun ayar yolu gösterilir; belgelenmemiş settings URL’leri kullanılmaz. Sportapp kendi bağlantısını kapatabilir ama HealthKit OS iznini sunucudan iptal etmiş gibi davranamaz.

İzinler uygulama-veri türü düzeyindedir; “yalnızca Huawei kayıtlarını oku” gibi Sportapp kaynak tercihi, OS’nin o marka için ayrı okuma izni verdiği şeklinde sunulmaz. Desteklenen source predicate/yerel filtreyle seçilmeyen kayıtların backend’e çıkması engellenir. Kaynak kökeni kesin değilse geniş izin varsaymak yerine belirsizlik gösterilir.

### 6.13 Google/Huawei köprüleri ve doğrudan uygulama hesabı izni

**Köprü yolu P0:** “Google Health/Huawei Health → Apple Health → Sportapp” akışında kullanıcının kaynak uygulamada ilgili Apple Health paylaşımını açması gerekir. Sportapp bu dış ayarı otomatik değiştirmez; doğrulanmış kurulum rehberi verir. Sportapp’ın ayrıca HealthKit okuma/işleme kapsamı olmalıdır. Google ile Sportapp’a giriş yapmak köprüyü açmaz. Huawei verisini HealthKit’ten okumak için sahte Huawei OAuth akışı eklenmez. [S12][S17]

**Doğrudan hesap API’si P1:** Resmî Google Health/Huawei Health API’si gerçekten devreye alındığında ayrı “Veri hesabını bağla” eylemi, minimum ve yalnızca doğrulanmış read scope’ları, sağlayıcı ekranı, callback, güvenli token saklama ve iptal akışı gerekir. P0’da bu bağlantının veri modeli/izin altyapısı bulunur; üretici onayı tamamlanmamış P1 entegrasyon P0’da çalışıyor gösterilmez.

Native kullanıcı yetkilendirmesi uygun sistem oturumu ve sağlayıcının desteklediği authorization-code/PKCE akışı üzerinden yapılır. Server-side confidential client yapılandırması varsa secret backend’dedir. OAuth `state`; hedef Sportapp hesabı, bağlantı türü, sağlayıcı, işlem amacı ve süre ile bağlanır. Kullanıcı yanlış hesabı seçerse kendi Sportapp login kimliği sessizce değiştirilmez. Yeni bağlantı için seçilen hesabın maskeli bilgisiyle açık doğrulama sunulur.

API entegrasyonunda istenen scope ile gerçekten verilen scope ayrı tutulur. Ek izin yalnızca ilgili özellik gerektiğinde istenir; refresh token’ın her dönüşte verileceği varsayılmaz ve boş dönüş mevcut geçerli refresh token’ı silmez. Onay ekranından dönmek, test sorgusu ve kategori kapsamı görülmeden “tüm veriler hazır” sayılmaz. [S36]

**Token alanları ayrıdır:** `AuthIdentity` oturum açma, `DataConnection` sağlık hesabı, `AIConnection` model servisi içindir. Google login ID token’ı sağlık API access token’ı yerine kullanılamaz. Aynı OAuth proje/client’ında grant/revoke etkisinin birden çok scope’u kapsayabileceği test edilir; normal logout’ta genel `disconnect/revoke` çağrısıyla kullanıcının bağımsız sağlık bağlantısı yanlışlıkla iptal edilmez. [S25][S36]

Samsung için doğrulanmamış iOS yolu hâlâ kapalıdır. İzin ekranı çizmek teknik erişim yaratmaz. Android Health Connect akışı bu iOS uygulamasına taklit edilmez; mevcut kaynak matrisi ve D0 doğrulama kapısı geçerlidir.

### 6.14 İzin iptali, bağlantı kesme ve geçmişin durumu

| Kullanıcı eylemi | Hemen duracak | Otomatik yapılmayacak |
|---|---|---|
| Bir kaynak bağlantısını duraklat | O bağlantıdan yeni read/upload/sync | Hesap silme veya izinli geçmişin kendiliğinden yok edilmesi |
| Bir veri kategorisinin Sportapp işleme iznini kaldır | O kategorinin yeni okunması/aktarılması ve izin gerektiren yeniden kullanımı | Kaynak uygulamadaki özgün veriyi silme |
| AI paylaşımını kaldır | Yeni ilgili AI çağrıları ve henüz gönderilmemiş işler | Daha önce dışarı gönderilmiş veriyi geri aldığını iddia etme |
| Koç erişimini kaldır | Sonraki API/görüntüleme/özet/bildirim ve kuyruk erişimi | Eski koçun dışarı indirdiği dosyayı uzaktan silme iddiası |
| HealthKit iznini iOS ayarından değiştir | OS’nin izin vermediği yeni okuma | İptali her durumda kesin tespit etme veya bütün geçmişe silme olayı uydurma |
| Sportapp’tan çık | İlgili istemci oturumu ve yerel okuma/upload | Bağımsız bulut veri grant’lerini sessizce topluca revoke etme |
| Sportapp hesabını sil | Yeni hesap etkinliği, veri alma, AI ve paylaşım | Apple/Google/Huawei/Samsung kaynağındaki kayıtları değiştirme |

**Bağlantıyı kesme** ile **Sportapp kopyasını silme** ayrı ve anlaşılır seçeneklerdir. İşleme izni kaldırılan veri backend’de görünür/aktif bağlam olarak kullanılmaya devam etmez; hangi saklama veya silme kuralının uygulanacağı kullanıcıya açıklanır. Zorunlu saklama gerekçeleri hukuken belirlenir; bütün geçmiş varsayılan sonsuz tutulmaz.

Geri çekme backend’de önce yetki sürümünü değiştirir; sonra native okuyucu, worker, koç cache’i ve AI bağlamları yeni duruma geçirilir. Offline telefon iptali henüz bilmese bile eski sürümlü batch’i sunucu kabul etmez. Henüz gönderilmemiş işler iptal olur. Gönderim başlamış AI isteği için mümkünse iptal denenir; sonuç karantinaya alınır ve kullanılmaz. Daha önce üçüncü tarafa çıkmış verinin hiç gönderilmediği söylenmez.

Sadece Apple Health read izninin OS’de değişmesi, geçmişte izinle sunucuya aktarılmış kopyayı uzaktan silmez. Sportapp kendi ayarında işleme/AI/koç/silme kontrollerini bu nedenle ayrıca sunar. Yeniden bağlantıda kaynak, kategori, tarih aralığı ve alıcı izinleri güncel hâliyle kontrol edilir.

### 6.15 İzin veri modeli ve ortak değerlendirme sözleşmesi

`ConsentGrant` en az `user_id`, gerektiğinde `athlete_id`, `purpose`, `recipient_type`, `recipient_id`, `data_categories`, `source_constraints`, `history_window`, `valid_from`, `expires_at`, `text_version`, `policy_version`, `status`, `decided_at`, `revoked_at`, `decision_origin` alanlarını temsil eder. Bunlar ürün izin kaydıdır; görünmeyen OS kararını kanıtlamaz.

`SourceAuthorizationObservation` istenen kategorileri, OS/API işleminin sonucunu, gözlenebilirlik düzeyini, verilen scope’ları **yalnızca sağlayıcı gerçekten açıklıyorsa**, kontrol zamanını ve gözlenen kapsamı tutar. HealthKit’e ilişkin `read_permission = UNKNOWN` geçerli bir sonuçtur.

`LocalHealthBinding` hesap, uygulama kurulumu, etkin oturum/installation epoch, içe aktarma tercihi ve sunucu izin sürümünü bağlar. Bu bir biyolojik kimlik veya iPhone’daki sağlık deposunun sahibini kesin tespit etme mekanizması değildir; kullanıcı sahiplik beyanı ve yanlış hesaba aktarımı engelleyen uygulama sınırıdır.

Ortak `PermissionDecision` aşağıdaki kesişimi değerlendirir:

```text
Kimlik ve hesap durumu
∩ Sportapp rol / sporcu erişim yetkisi
∩ Kaynağın izin verdiği kullanım
∩ Kullanıcının geçerli kategori / amaç / kaynak / tarih aralığı
∩ Alıcı izni (AI veya belirli antrenör gibi)
∩ İşlem bağlamı ve güncel izin sürümü
→ ALLOW / DENY / REQUIRE_USER_ACTION / UNKNOWN_SOURCE_ACCESS
```

LLM bu sonucu değiştiremez. Her okuma/yükleme/AI/koç/API aracı aynı sunucu kararını kullanır. Üretilmiş bir açıklama da izin dışı uyku veya sağlık bilgisini ifşa edebileceğinden yalnızca ham alan filtreleme yeterli değildir; türev kaynak bağımlılıkları ve alıcıya uygun özet yeniden hesaplanır.

**Yayın belgeleri:** `CONSENT_MATRIX.md`, `PERMISSION_FLOWS.md`, sürümlü amaç metinleri, kategori→kaynak scope eşlemesi, HealthKit Info.plist/capability listesi, revoke/delete akışları ve gerçek cihaz izin testleri hazırlanır. Bu belgeler yalnızca ekran tasarımı değil backend/native enforcement kanıtını da içerir.

## 7. Özellik listesi — Dönem stratejisi ve haftalık plan oluşturma

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| PLAN-01 | P0 | İlk dönem stratejisi | Hedef tarihleri ve önceliklere göre esnek çalışma dönemleri; yakın dönem ayrıntılı, uzak dönem amaç seviyesinde. |
| PLAN-02 | P0 | İlk haftalık plan | Branş bazlı profil, gerçek geçmiş, hedef, uygunluk ve ekipmandan tipli seanslarla hafta oluşturur. HIIT/fonksiyonel/Pilates gerçek planlama paketleridir; boş başlangıçta açık varsayımlar. |
| PLAN-03 | P0 | Mevcut planla başlama | Kullanıcı/antrenör planını yapılandırılmış olarak girebilir; AI geçmişi silerek sıfırdan başlamaz. |
| PLAN-04 | P0 | Plan önizleme | Haftanın amacı, her seansın neden seçildiği, toplam süre, anahtar seanslar, varsayımlar ve veri eksikleri görünür. |
| PLAN-05 | P0 | Manuel düzenleme | Seans taşıma, silme, süre/ekipman değiştirme; her değişiklik aynı kontrollerden geçer. |
| PLAN-06 | P0 | Seans kilitleme | Sabit randevu, yarış ve dinlenme günü kuralları; sistem gerektiğinde çatışmayı gösterir, sessizce bozmaz. |
| PLAN-07 | P0 | Yayınlama ve sürüm | Taslak, doğrulama, onay, yayın; kimin neyi değiştirdiği ve önceki sürüm saklanır. |
| PLAN-08 | P0 | Haftalar arası devamlılık | Geçen hafta gerçekten yapılanlar ve tolerans sonraki haftaya taşınır. Takvim haftası sınırında yük sıfırlanmaz. |
| PLAN-09 | P0 | Hafta ortasında başlangıç | Başlanmış günler ve gerçek aktiviteler korunur; kalan haftaya sığmayan seanslar sıkıştırılmaz. |
| PLAN-10 | P0 | Haftalık değerlendirme | Plan/gerçekleşen farkı, ana amaçlar, geri bildirim, veri eksikleri ve sonraki haftanın önerilen değişimi. |
| PLAN-11 | P0 | Otomatik yeni hafta taslağı | Kullanıcının seçtiği planlama günü/zaman penceresinde, geçerli izin ve bütçeyle üretim; otoriteye göre onay. |
| PLAN-12 | P1 | Plan içe aktarma | Metin/dosya planı LLM ile taslağa çevirme; sayı ve egzersizler kullanıcı doğrulamasından geçer. |

### 7.1 Haftalık plan girdileri

Aktif yarış ve yarış dışı hedefler, varsa tarihler; seçilen branş/varyant, branşa özgü deneyim, sabit ders/maç, ilgili içerik ve destek/politika sürümü; dönem stratejisi; son onaylı plan; dış uygulamalardan içe aktarılmış ve eşleşmemiş aktiviteler, ayrı kullanıcı beyanları; ilgili geçmiş yük ve tolerans; seanslar arası gerçek zaman aralığı; güncel kullanıcı bildirimi; uygulama/erişim yolu, veri türü bazlı güncellik ve eksik kapsam bilgisi; güncel performans referansları; müsaitlik; ekipman; antrenör politikası; yayın otoritesi; AI sağlayıcı izni; antrenman kütüphanesi ve politika sürümü.

Plan için bir **veri anı görüntüsü** oluşturulur. Hangi verilerin hangi sürümünün kullanıldığı sabitlenir. Uzun bir model isteği tamamlanırken yeni aktivite gelirse plan doğrudan yayımlanmaz; güncellik kontrolüyle yeniden değerlendirilir.

### 7.2 Haftalık plan çıktısı

Her hafta için amaç, öncelik sıralaması, planlanan seanslar, dinlenme/kısıtlı günler, zaman bütçesi, karşılanamayan hedefler, açıklanmış varsayımlar, önemli kısıtlar ve onay durumu bulunur.

Her seans en az şu alanları taşır:

`session_id`, `goal_refs`, `purpose`, `sport_discipline_id`, `sport_variant_id`, `training_method_ids`, `workout_format`, `catalog_version`, `discipline_policy_version`, `block_schema_version`, `priority`, `scheduled_window`, `timezone`, `estimated_total_duration`, `location_type`, `equipment`, `warmup`, `main_blocks`, `cooldown`, `intensity_targets`, `target_basis`, `alternative_options`, `adjustment_permissions`, `reason_codes`, `evidence_refs`, `status`.

Seans blokları Bölüm 11.9'daki tipli yapılara göre ayrışır: dayanıklılık, kuvvet, interval/devre, Pilates, yoga/mobilite, yüzme, teknik drill, round/seri, sabit ders/maç ve karışık seans. Uygulanamaz alanlar zorunlu değildir. Her hareket/drill/poz bir içerik ID/sürümü ve plan anındaki snapshot ile bağlanır. Eski `sport_type` alanı gerekirse uyumluluk projeksiyonu olarak tutulur; yeni modelin tek kaynağı yapılmaz. Aynı haftaya farklı branş koymak, ortak süre bütçesi dışında her branşın kendi amaç, ekipman ve deneyim koşullarını da kontrol etmeyi gerektirir.

**Toplam süre backend tarafından hesaplanır.** Modelin yazdığı toplam tek başına doğrulanmış toplam kabul edilmez. Belirsiz sürelerde aralık gösterilir. Serbest metin açıklama ile yapılandırılmış sayılar çelişirse doğrulama başarısız olur veya açıklama doğrulanmış sayılardan yeniden üretilir.

### 7.3 Uygun plan bulunamaması

Katı kısıtlar nedeniyle uygun plan yoksa `INFEASIBLE` döndür. Çatışan kısıtları ve kullanıcı/antrenörün değiştirebileceği seçenekleri göster. Güvenlik sınırını, erişim iznini veya dinlenme günü kilidini hedefi sağlamak için otomatik kaldırma. Hedef süreye ulaşmayı garanti etme.

### 7.4 Veri okuma mimarisinin planlamaya etkisi

İlk hafta için önce mevcut uygulama verileri kullanılır; bilinen süre, tür ve tarihleri kullanıcıya tekrar tekrar yazdırma. Veri aktarılamıyorsa hangi alanın eksik olduğu söylenir. Başlangıç planı sınırlı veriyle üretilebilir; yeterli veri varmış gibi kişiselleştirme iddiası kurulmaz.

Plan oluşturulduğunda bilinen son veri ve kapsanan dönem gösterilir. Yeni dış uygulama kaydı, önceki bir seansın düzeltmesi veya gecikmiş uyku kaydı önemliyse aktif planın sonraki kısmı yeniden değerlendirilir. Her yeni örnek tüm haftayı yeniden yazdırmaz.

Seans reçetesindeki hedef süre, mesafe, nabız, tempo, set ve tekrarlar **planlanan değerlerdir**. İçe aktarılmış gerçekleşen değerlerle aynı alanlara veya dış sağlık deposuna yazılmaz.

## 8. Özellik listesi — Günlük uyarlama ve seans rehberi

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| ADAPT-01 | P0 | Seans öncesi değerlendirme | Mevcut içe aktarılmış veri, son eşitleme ve kullanıcı geri bildirimiyle öneriyi kontrol eder; canlı ölçüm başlatmaz. |
| ADAPT-02 | P0 | Kaçan/kısmi seans | Taşıma, kısaltma, değiştirme veya kaldırma; kayıt gecikmesini kaçırma sanma. |
| ADAPT-03 | P0 | Plansız aktivite | Dış uygulamadan gelen veya beyan edilen plansız aktiviteyi; Pilates, HIIT, yüzme, basketbol, tenis, koşu veya kuvvet ayrımıyla sonraki karara katma; veri ayrıntısını uydurmama. |
| ADAPT-04 | P0 | Durum değişikliği | İçe alınan uyku/diğer kayıtlar ve bildirilen yorgunluk/rahatsızlığı kaynağıyla ele alma. |
| ADAPT-05 | P0 | Süre/ekipman değişikliği | Amacı mümkün olduğu ölçüde koruyan uygulanabilir alternatif; tüm sporları aynı süreyle eşdeğer sayma. |
| ADAPT-06 | P0 | Plan farkı önizlemesi | Bugünkü değişiklik ve sonraki günlere etkisi birlikte görünür. |
| ADAPT-07 | P0 | Minimum gerekli değişiklik | Küçük değişiklikte bütün hafta yeniden yazılmaz; değişiklik sıklığı izlenir. |
| ADAPT-08 | P0 | Açıklanabilirlik | İçe aktarılmış olgu, kullanıcı beyanı, türetilmiş değerlendirme ve belirsizlik ayrı açıklanır. |
| ADAPT-09 | P0 | İzinli otomasyon | Sporcu/antrenör politikasının dışına çıkmaz; önemli değişiklik için onay. |
| GUIDE-01 | P0 | Seans reçetesi ekranı | Isınma, çalışma blokları, dinlenme, soğuma ve hedef yoğunluk; canlı değer/kayıt ekranı değildir. |
| GUIDE-02 | P0 | Tamamlama beyanı ve geri bildirim | “Yaptım/kısmen yaptım/yapmadım” ve zorluk; isteğe bağlı, kayıt zamanlayıcısı olmadan. |
| GUIDE-03 | P0 | Çevrimdışı plan | Son onaylı reçete yerel okunur; geri bildirim sonra idempotent gönderilir. |
| GUIDE-04 | P0 | Plan değişikliği bildirimi | Tekrarsız, sessiz saatlere uygun ve hassas sağlık bilgisi açığa çıkarmayan bildirim. |
| GUIDE-05 | P0 | İçe aktarım/eşleştirme görünümü | “Dış kaydı bekliyoruz / kayıt eşleşti / ayrıntı eksik” ve düzeltme akışı. |

### 8.1 Kritik uyarlama kuralları

Veri gelmediği anda seansı `SKIPPED` yapma. `AWAITING_DATA`/`USER_REPORTED_DONE` gibi durumlarla kayıt kanıtını ayrı tut. Kullanıcının açık beyanı veya uygun uzlaştırma olmadan ölçülmüş gerçekleşme varsayılmaz.

Seanslar arası süre, varsa dış kayıttaki gerçek bitiş ile sonraki planın başlangıcı arasından hesaplanır. Kaynak sadece toplam süre veriyorsa gerçek bitiş saati uydurulmaz. Saat dilimi, gece yarısı ve hafta sınırı test edilir.

Kardiyovasküler, kuvvet, darbeli aktivite ve bölgesel kullanıcı beyanı ayrı özelliklerdir. Bölgesel yük göstergesi sensörle ölçülmüş kas toparlanması değildir. Tek bir HRV veya üretici hazırlık puanı bütün kararı belirlemez.

Yoğunluk önerisi, kaynaktan gelen kişisel referanslar, antrenör tanımı veya açıkça etiketlenmiş değerlendirmeye dayanır. Güvenilir nabız referansı yoksa kesin bpm aralığı uydurma; uygun RPE gibi başka yönlendirme kullan. Sportapp kullanıcının o an nabzını görmediği için “şu anda 165, yavaşla” gibi canlı koçluk iddiası kurmaz.

Dışarıda uygulanmış/uygulanmakta olduğu bildirilen seans sessizce yeniden yazılmaz. Sağlık şikâyeti bildirildiğinde uzman incelemeli güvenlik akışı devreye girebilir; bu bir sensör alarmı veya dış uygulamayı otomatik durdurma komutu değildir. Uygun durumda antrenman önermemek de geçerli sonuçtur.

**Çok sporlu uyarlama:** Bölüm 11.11'deki kurallar her branşa uygulanır. Bir Pilates dersi, koşu veya HIIT seansı yerine yalnızca süresi aynı diye yazılamaz. Sabit ders/maçların taşınabilirliği ayrı; hedef ve beceriye uygun alternatifler gereklidir. Kaynak sadece genel seans özeti sağlıyorsa kas/set bazlı gerçekleşen yük bilinmiyor olarak kalır. Yük veya yoğunluk referansları bütün branşlara kopyalanmaz.

### 8.2 Kullanıcı senaryosu

Dün akşam yapılan uzun koşu dış uygulamadan 22:20 bitiş saatiyle gelmiş olsun. Kullanıcı bugün 12:00’de çalışacak, 35 dakikası olduğunu ve bacak yorgunluğunu bildiriyor. Sistem bu kayıtlar ile mevcut haftalık hedefleri değerlendirir, gerekiyorsa bugünkü seansı ve kalan haftayı değiştiren taslak sunar. Kaynakta yalnızca koşunun süresi varsa 22:20 bitişi icat etmez; belirsizliği korur.

Bu örnekte Sportapp koşuyu kaydetmez, nabzı ölçmez, uyku sensörünü çalıştırmaz. Görevi **mevcut bilgiyle plan kararı vermek ve yeni bilgiyle bu kararı güncellemektir**.

## 9. Antrenör, geçmişin taşınabilirliği ve web yönetimi

**v6 platform kararı:** Aşağıdaki COACH kodlu bütün P0 işlevler iPhone uygulamasındaki antrenör çalışma alanında erişilebilir olur. 9.1–9.10’daki ADMIN/BILL/CRM işlevleri ise özel web admin paneline aittir; aynı istemciye zorla birleştirilmez. Masaüstü antrenör web panelinin P1 olması COACH özelliklerini P1 yapmaz. Antrenör kendi iPhone HealthKit deposunu müşterilerinin verisi gibi okuyamaz; sporcuların izinli backend kayıtları üzerinden çalışır.

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| COACH-01 | P0 | Davet ve kabul | Antrenör daveti tek başına erişim sağlamaz; sporcu kapsamı görüp onaylar. |
| COACH-02 | P0 | Sporcu listesi | Yaklaşan seanslar, değişiklikler, veri eksikliği ve onay bekleyen öneriler. |
| COACH-03 | P0 | Son incelemeden beri değişenler | Ek/kısmi/kaçan seanslar, yeni geri bildirim, kaynak uygulama kayıtları ve güncel olmayan/eksik veriler. |
| COACH-04 | P0 | Haftalık plan oluşturma | Manuel, AI ile ve kütüphane şablonundan; hepsi aynı kontrol ve sürümleme yolunda. |
| COACH-05 | P0 | Seans öncesi brifing | Mevcut plan, dış uygulamalardan son gelenler, en son eşitleme, önerilen değişiklik ve eksikler; telefon eşitlemesi yoksa panel bunu söyler. |
| COACH-06 | P0 | Onay ve ret gerekçesi | Öneriyi kabul/düzenle/reddet; gerekçe öğrenme ve ürün değerlendirmesi için sınıflanır. |
| COACH-07 | P0 | Yetki sınırları | Hangi değişiklik otomatik olabilir, hangi seans kilitli, kim yayımlar. |
| COACH-08 | P0 | Not görünürlüğü | Sporcuya açık not, antrenöre özel çalışma notu ve hassas kayıt açıkça ayrılır. |
| COACH-09 | P0 | Antrenör değiştirme | Sporcu hesabı değişmez; eski erişim iptal edilir, yeni antrenör yeni kapsamla yetkilendirilir. |
| COACH-10 | P0 | Devir özeti | Paylaşılabilir hedef, gerçekleşen plan, önemli kısıt, test ve geçmiş değişikliklerin yapılandırılmış özeti. |
| COACH-11 | P1 | Organizasyon çalışması | Ekip rollerinin, ortak çalışma ve organizasyon AI bağlantılarının yönetimi. |

Sporcu geçmişi antrenör organizasyonunun altına hapsedilmez. Sporcuya ait kayıtlarla antrenörün özel notlarının erişim ve saklama politikası ayrı tasarlanır. İzin iptali API, native iPhone, P0 admin web’indeki izinli görünümler, varsa P1 antrenör web, cache, kuyruk işleri ve dışa aktarma bağlantılarında uygulanır. Önceden dışa aktarılmış ve alıcının cihazında bulunan dosyaların uzaktan geri alınamayacağı açıklanır.

P0’da antrenörün kendi API anahtarı müşteriye ait veriye otomatik yetki vermez. Sporcuya ait AI bağlantısı ve açık veri paylaşım politikası kullanılır. Organizasyonun ödeme yaptığı AI bağlantısı P1’de eklenirse veri sahibi izni, alıcı bilgisi ve ödeme sorumlusu ayrı alanlar olur.

**Branş ve içerik yetkisi:** Antrenör çalıştırdığı branşları/uzmanlık bağlamını belirtir. Plan editöründe branşa göre hareket/drill/poz kategorileri ve tipli doz alanları açılır. Sabit ders ile ayrıntılı reçete ayrı kayıttır. Sporcu geçmişinin taşınması, önceki antrenörün tüm özel şablon/medya kütüphanesinin devri değildir; Bölüm 11.12'nin erişim ve snapshot kuralları uygulanır.

### 9.1 Web admin paneli — ürün sahibi için P0

Bu panel sporcuların kullandığı iPhone uygulamasının yerine geçmez ve antrenörün müşterisine program yazdığı P1 web uygulaması değildir. Amaç, ürün sahibinin tek ekrandan “kim kaydoldu, üyeliği nedir, ücret/ödeme ne durumda, kimle ne konuşuldu ve kimi takip etmeliyim?” sorularını cevaplamasıdır. Ayrı bir CRM satın alma veya harici servis entegrasyonu ilk sürüm koşulu değildir.

**P0 sınırı:** Kayıtlı üye yönetimi + ticari üyelik/ödeme görünürlüğü + minimum destek/CRM + önceki katalog/operasyon yönetiminin güvenli web sunumu. Tam muhasebe, teklif/satış pipeline’ı, pazarlama otomasyonu, çağrı merkezi, kullanıcı adına oturum açma ve antrenörlere komisyon dağıtma eklenmez.

### 9.2 Özellik listesi — Web admin ve operasyon

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| ADMIN-01 | P0 | Web admin uygulaması | Ayrı tarayıcı arayüzü; kayıtlı kullanıcı, üyelik/ücret, CRM ve operasyon ekranları ortak backend üzerinde çalışır. API/CLI veya demo tablo tek başına teslim değildir. |
| ADMIN-02 | P0 | Davetli personel ve MFA | Herkese açık admin kayıt yok; güvenli ilk sahip kurulumu, personel daveti, MFA, kurtarma ve hızlı oturum iptali. Genel uygulama login’i yetki yükseltmez. |
| ADMIN-03 | P0 | DB tabanlı rol ve izinler | OWNER/ADMIN/SUPPORT/FINANCE başlangıç şablonları; izin/atama/scope DB’de sürümlü, her API ve export’ta zorunlu. UI gizleme veya sabit e-posta listesi güvenlik değildir. |
| ADMIN-04 | P0 | Kayıtlı kullanıcı listesi | Arama, sayfalama, sıralama; kayıt/doğrulama/rol/hesap/üyelik/son giriş filtreleri; sosyal kimlik sayısını kullanıcı adedi saymaz. |
| ADMIN-05 | P0 | Kullanıcı ayrıntı kartı | Kimlik/iletişim özeti, hesap durumu, üyelik, izin verilen ödeme özeti, CRM/destek ve idari olaylar. Ham sağlık/koç notu/anahtar yok. |
| ADMIN-06 | P0 | Güvenli hesap işlemleri | Gerekçeli askıya al/geri aç, güvenli doğrulama/kurtarma talebini yeniden gönder ve oturum iptali; şifre/token gösterme veya ödeme iptali varsayma yok. |
| ADMIN-07 | P0 | Operasyon dashboard’u | Yeni/toplam doğrulanmış kullanıcı, aktif kullanıcı tanımı, ücretsiz/ücretli üyelik, dönem içi işlem/iade, açık görev/destek ve mutabakat sorunları; gerçek kaynak ve güncellik. |
| ADMIN-08 | P0 | İşlem ve erişim denetimi | Aktör/hedef/işlem/gerekçe/sonuç/sürüm/zaman; hassas değişiklik ve export audit’i; PII minimum, yetkili saklama/anonimleştirme, audit’i panelden silme yok. |
| ADMIN-09 | P0 | AI kullanım ve maliyet görünümü | Kullanıcı/paket bazlı izinli görev/kota/latency/hata özeti; platform maliyeti ve BYOK ayrı. Bilinmeyen sağlayıcı maliyeti sıfır veya kesin ücret sayılmaz; prompt/anahtar gösterilmez. |
| ADMIN-10 | P0 | Sınırlı ürün/servis ayarları | Fiyat paketi ve kota policy referansları, varsayılan platform LLM secret referansı, güvenli kill switch. Alıcı değişiminde mevcut AI izinleri yeniden değerlendirilir. |
| ADMIN-11 | P0 | Mevcut katalog yönetimini sunma | Kaynak import/coverage, eşleme, çeviri ve review/yayın işlerinin yetkili web karşılığı; SPORT rollerini ve önceki içerik sınırlarını kullanır. |
| ADMIN-12 | P0 | Sınırlı rapor dışa aktarımı | Filtreli kullanıcı/üyelik/işlem CSV; alan yetkisi, satır sınırı/asenkron iş, kısa ömürlü özel indirme ve denetim. CSV hücreleri formül yürütmeyecek biçimde korunur. |
| ADMIN-13 | P0 | Kontrollü idari eylemler | Etki önizlemesi, gerekçe, idempotency, sürüm/step-up kontrolü; güvenli retry ve durum sorgusu. Destek ekranından izinsiz AI gönderimi, tahsilat veya plan yayını yok. |
| ADMIN-14 | P0 | Web kalite ve işletim | Responsive masaüstü/tablet, erişilebilir tablo/form, TR/EN, hata/boş/yükleniyor; tarayıcı matrisi, güvenli cookie/CSRF/CSP, staging-prod ve sürüm uyumu. |

### 9.3 Özellik listesi — Üyelik, paket, ücret ve ödeme

Bütün satırlar P0 ürün gereksinimidir. **Satış-kapılı satırlarda P0 koşulu:** Ücretsiz modda gerçek kullanıcı/üyelik/CRM çalışır, para akışı ve paywall kapalıdır; ödeme satırları karar ve test durumu ile görünürdür, sahte işlem üretilmez. Ücretli modda etkinleştirilen ilk satış kanalı BILL-04–BILL-14 kapsamındaki doğrulama ve gerçek sandbox testlerini geçmeden ücret alınamaz. Seçilmemiş ikinci/üçüncü sağlayıcıyı entegre etmek P0 şartı değildir. Bedelsiz erişimi “tahsil edildi” göstermek hiçbir modda kabul edilmez.

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| BILL-01 | P0 | Paket ve fiyat kataloğu | Teknik rol değil ticari paket; ücretsiz, bedeli karşılanan, tek seferlik/süreli ve seçilirse dönemsel türler. Fiyat/para birimi/kanal/geçerlilik/sürüm; geçmiş fiyatı ezme yok. |
| BILL-02 | P0 | Üyelik yaşam döngüsü | Başlangıç/bitiş, ürün/paket, erişim kapsamı, kaynak, ödeme yapan ile yararlanan, yenileme tercihi ve durum. Bir üyelik her zaman otomatik yenilenen abonelik değildir. |
| BILL-03 | P0 | Erişim hakkı ve kota | DB’den hesaplanan EntitlementGrant/Policy; finans olayından ayrı, sunucuda her ücretli eylemde uygulanır. Ücret rol/sağlık izni açmaz; ücretsiz/bedelsiz hak sıfır satıştır. |
| BILL-04 | P0 | Ödeme ve finansal olay geçmişi | Kanal/sağlayıcı/environment/işlem kimliği/üye/tutar/durum/zaman; pending/failed/succeeded/refund ayrımı, manuel kayıtların ayrı kökeni. Gerçek kart verisi saklama yok. |
| BILL-05 | P0 | Satın alma doğrulaması ve hesap bağlama | Seçili sağlayıcının güvenli sunucu doğrulaması; Apple için imzalı veri, uygulama/ortam/ürün/işlem/sahiplik. Ekran görüntüsü veya client paid=true yeterli değildir. |
| BILL-06 | P0 | iPhone ödeme/üyelik deneyimi | Üyelik ekranı, geçerli fiyat/koşul, seçili kanalda satın al/geri yükle/yönet/destek; pending/iptal/doğrulama bekliyor. Ücretli dijital satış açılırsa ilgili StoreKit yolu yayın kapısıdır. |
| BILL-07 | P0 | Doğru tutar ve dönem modeli | Exact decimal veya ölçeği açık tamsayı, para birimi ve kaynak birimi korunur; FLOAT ve her tutarı iki ondalık varsayma yok. Zaman/kanal/vergiler/maliyet alanları ayrı. |
| BILL-08 | P0 | İptal, iade ve geri alma takibi | Kullanım sonu, auto-renew off, iade talebi ve doğrulanmış iade ayrı. Kanal gerçek eylemi desteklemiyorsa yalnızca yönlendirme/durum; sahte başarılı refund yok. |
| BILL-09 | P0 | Bildirim ve mutabakat | İmza/kimlik, duplicate/out-of-order, retry ve kayıp webhook; periyodik/istekli yetkili sağlayıcı sorgusuyla uzlaşma. Sandbox satışları prod gelire/hakka karışmaz. |
| BILL-10 | P0 | Üyelik ve tahsilat raporu | Dönem/para birimi/kanal/paket bazlı brüt işlem, başarılı iade, iade sonrası toplam ve ayrı sağlayıcı ödemesi. Muhasebe kârı veya doğrulanmamış net gelir iddiası yok. |
| BILL-11 | P0 | Belge ve referans takibi | Sağlayıcı makbuz/fatura referansı, tarih, durum ve izinli güvenli belge erişimi; işlem kaydını yasal fatura sayma veya otomatik vergi oranı üretme yok. |
| BILL-12 | P0 | Bedelsiz hak ve sınırlı manuel kayıt | Yetkili süreli telafi/ücretsiz erişim gerekçe ve bitişle; bankadan/manual tahsilat yalnız onaylı satış türü/kanalda delilli ve mutabakatlı. App Store’u atlama yolu değil. |
| BILL-13 | P0 | Üyelik bildirimleri ve kısıtlar | Yaklaşan gerçek bitiş, yenileme kapalı, doğrulanmış ödeme sorunu için sade gösterim ve uygun servis mesajı; yeni AI hakkı bitse de geçmiş/izin/hesap silme erişimi korunur. |
| BILL-14 | P0 | Ticari kanal ve yayın kapısı | BILLING-001; mağaza/bölge/ürün türü/sağlayıcı kuralı ve gerçek sandbox doğrulaması. Üyelik takibi P0; satış aktivasyonu açık karara bağlı, bütün kullanıcılara abonelik yok. |

### 9.4 Özellik listesi — Minimum CRM

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| CRM-01 | P0 | Kayıtlı üyeden CRM kartı | Var olan User ile tekil bağlı CRM kaydı; tekrar event, Apple/Google bağlama veya sporcu/antrenör rol değişimi yeni müşteri çoğaltmaz. Harici lead havuzu şart değil. |
| CRM-02 | P0 | İletişim ve yaşam döngüsü özeti | Mevcut doğrulanmış iletişim, isteğe bağlı telefon, kayıt/onboarding/son giriş ve servis iletişim tercihi; CRM’de düzenleme auth kimliğini/e-posta doğrulamasını değiştirmez. |
| CRM-03 | P0 | Etiket ve basit filtreler | Örn. onboarding yardımı, ödeme incelemesi, geri dönüş bekleniyor; seçili filtreyi kaydet. Sağlık, spor performansı veya hassas davranıştan pazarlama segmenti üretme yok. |
| CRM-04 | P0 | İdari not ve etkileşim kaydı | Destek/iletişim amaçlı kısa not, kanal, tarih ve yazar; düz metin/güvenli render, sürüm ve düzeltme izi. Koçun özel notunu, sağlık geçmişini veya API anahtarını kopyalama yok. |
| CRM-05 | P0 | Sorumlu ve takip görevleri | Tek personel sorumlusu, konu, öncelik, durum, son tarih, sonuç; benim görevlerim/gecikenler ve dahili hatırlatma. Çok katmanlı süreç motoru yok. |
| CRM-06 | P0 | Basit destek kayıtları | iPhone yardım formu veya yetkili personel oluşturur; kullanıcı, kategori, mesaj, sorumlu, öncelik, durum, açık yanıt ve kapanış. İç not ile kullanıcıya yanıt kesin ayrılır. |
| CRM-07 | P0 | İletişim ve servis mesajı takibi | Tekil destek yanıtı/işlemsel şablon ve manuel arama/e-posta temas kaydı; gönderildi/teslim/red/bilinmiyor ayrımı. Toplu kampanya, inbox senkronu ve otomatik pazarlama P0 değil. |
| CRM-08 | P0 | CRM mahremiyet ve saklama | Rol bazlı görüntüleme, minimum alan, düzeltme/silme politikası ve hesap yaşam döngüsüyle temizlik; silinmiş kullanıcıyı eski event tekrar oluşturamaz. Genel ticari onay sağlık/AI izni değildir. |

### 9.5 Yetki, giriş ve hassas veri sınırı

| İşlem | Platform sahibi / ADMIN | SUPPORT | FINANCE |
|---|---|---|---|
| Kullanıcı liste/kart | İzinli idari alanlar | Görevi için gereken alanlar | Mali eşleştirme için gereken kimlik |
| CRM not/görev/destek | Yetkisi kadar | Yetkisi kadar | Yalnız mali destek kapsamı varsa |
| Üyelik/ödeme özeti | Evet | Sınırlı, değiştiremez | Evet |
| Fiyat/paket yayımlama | Açık ticari izin + etki önizlemesi | Hayır | Atanmış fiyat yetkisiyle |
| Telafi erişimi / mali düzeltme | Açık yetki + gerekçe + step-up | Hayır | Atanmış mali yetki + step-up |
| Personel rolü / kritik sistem ayarı | Yalnız atanmış yüksek yetki; son OWNER korunur | Hayır | Hayır |
| Ham sağlık / antrenör özel notu / BYOK anahtarı | Varsayılan hayır | Hayır | Hayır |

Bu tablo başlangıç rol şablonudur; roller, izin bağları ve atamalar DB’de tutulur. Backend’de tanımlı eylem anahtarları vardır; gelişi güzel string veya client `role=ADMIN` göndermek yetki oluşturmaz. `Role`, `Permission`, `RolePermission`, `AdminStaffMembership` ve scope/version ilişkileri gerektiğinde mevcut RBAC şemasıyla birleştirilir. Tek ürün kurulumu için platform kapsamı yeterlidir; organizasyon/tenant varsa sorgu ve export o scope’ta filtrelenir. Organizasyon yöneticisi platform admin’i değildir. Varsayılan ret ve her istekte yetki kontrolü yaklaşımı uygulanır. [S56]

Admin arayüzüne ayrı HTTPS origin veya açık güvenlik sınırı tanımlanır. Davet, MFA enrollment/recovery, idle/absolute timeout ve oturum iptali zorunludur. İlk sahip bir defalık güvenli işlemle atanır; açık kayıt, seed’de sabit parola, e-posta domaini veya web route gizlemek güvenlik sayılmaz. Son etkin OWNER kaldırılamaz; yüksek yetkili işlemde gerekçe ve step-up gerekir. İkinci çalışan yokken her işlem için zorunlu iki kişi şartıyla ürün kilitlenmez; ek onay ancak risk/politika gerektiriyorsa kullanılır.

Admin cookie’si host-sınırlı Secure/HttpOnly ve akışa uygun SameSite’dır; mutasyonlarda framework’ün doğrulanmış CSRF koruması ve origin kontrolleri vardır. CORS yetkilendirmenin yerine geçmez. Not ve mesajlar güvenli render edilir; admin ekranları ve yanıtları paylaşılan cache’e konmaz. Public sağlık veya AI API’lerindeki kontroller admin endpoint’lerinde bypass edilmez. [S57]

Kullanıcı destek mesajına kendisi sağlık ayrıntısı yazarsa uyarı, minimum toplama, dar destek scope’u, kısa saklama ve gerekli redaksiyon akışı uygulanır; CRM’ye serbest sağlık deposu kurulmaz. Admin finans işlemini LLM’e delegasyonla yaptıramaz. P0 CRM notları/ödeme bilgileri dış LLM’e otomatik gönderilmez. Operasyon personeli koçla aynı kişi olsa da sağlık içeriği yalnız koç çalışma alanında geçerli sporcu izniyle görünür.

### 9.6 Ticari model ve App Store ödeme kanalı

**Paket ≠ abonelik:** `FREE`, bedelsiz `COMPLIMENTARY`, süresi açık `FIXED_TERM`/tek seferlik ve ancak seçilirse `AUTO_RENEWING` ticari modelleri ayrı tanımlanır. Kurumun ödediği erişim, ödeme yapan kişi/kurum ile yararlanan kullanıcıyı ayırır; P1 çok kiracılı organizasyon ürünü veya kurum satış ekranları bu alan nedeniyle P0’ya çekilmez. Gerçek ürün adları, fiyatlar ve ücretsiz deneme süreleri ürün sahibi kararından gelir; bu belge tutar belirlemez. Her kayıtlı kullanıcıya ücret yazılmaz.

**Apple kuralları için kontrol (25 Eylül 2026):** Uygulama içi dijital özellik/erişim satışı için ana kural In-App Purchase’tır. Gerçek zamanlı iki kişi arasındaki koçluk ve uygulama dışında tüketilen hizmetler farklı maddelerdir; AI’ın verdiği plan otomatik olarak birebir insan hizmeti sayılmaz. Dış satın alma bağlantılarında mağaza/bölge ve özel koşullar vardır; ABD veya başka bir pazar istisnası Türkiye dahil bütün pazarlara genellenmez. Özel admin web paneli bir ödeme kuralı istisnası yaratmaz. [S1]

**D0 kararı:** Satılan şey, satıcı/ödeme alan, hedef storefront, satış/yönetim yolu, izin verilen dış linkler, uygun App Store ürün türü, müşteri koşulları, fiyat/para birimi, fatura/vergi sorumluluğu ve test kanıtı `BILLING_CHANNEL_MATRIX.md` içinde yazılır. Varsayılan güvenli referans, iOS içi ücretli dijital erişim açılıyorsa StoreKit + sunucu doğrulamasıdır. Web checkout veya banka kaydı yalnız doğrulanmış kanal için açılır; panelden sonradan etiket değiştirerek kurallar aşılmaz.

**Native satın alma akışı:** Kullanıcı seçili Sportapp hesabına bağlı olduğunu görür → mağazadan güncel yerelleştirilmiş ürün/fiyat/koşul alınır → resmî satın alma akışı → bekleme/iptal/başarı → sunucu doğrulaması → üyelik/erişim görünümü. Uygulama satın alma sırasında kapanırsa geri geldiğinde işlemi uzlaştırır; yeniden para çekmez. Geri yükleme ve destek/yönetim seçenekleri vardır. Yeni StoreKit görünümleri zorunlu tutulmaz; mevcut iOS destek sözleşmesine uygun temel API/UI alternatifi kullanılır. iOS 14 açık kararı bu modülle sessizce daraltılmaz. StoreKit imzalı işlemler, erişim ve destek akışları sağlar; API yeteneği ile bu projede test edilmiş entegrasyon ayrı kaydedilir. [S54]

**Ürün kataloğu ve gerçek fiyat:** Panel `BillingProduct` ve sürümlü `PriceVersion` tanımlar; App Store `product_id` eşlemesi ayrıca tutulur. Admin’de fiyat düzenlemek App Store fiyatını değiştirmiş sayılmaz. App Store Connect’te onaylanmış ürün/fiyat yoksa `DRAFT` veya `NOT_READY_FOR_SALE`; iPhone ödeme ekranı yerel panel fiyatı yerine kanalın gerçek teklifini gösterir. Önceki işlemin tutarı/paket sürümü değişmez. Plan yükseltme/düşürme ve kıst ücret davranışı seçili sağlayıcının kurallarıyla izlenir; rastgele fark tahsil edilmez.

### 9.7 Üyelik, erişim hakkı ve kullanıcı hesabı

`Membership` ticari ilişkiyi; `EntitlementGrant` neye, ne zamana kadar erişileceğini; `PaymentTransaction/FinancialEvent` para olayını; `ConsentGrant` ise veri kullanımını anlatır. `User.status` bunlardan ayrıdır. Kullanıcı üyelik satın aldığında koç/admin rolü veya sağlık paylaşımı kazanmaz. Süreli bedelsiz erişim kaynağı, kapsamı, başlangıç/bitişi, gerekçesi ve aktörüyle tutulur; ücretli ödeme kaydı yaratılmaz.

Üyelik durumları ürün normalizasyonudur: `FREE`, `TRIAL`, `ACTIVE`, `GRACE`, `EXPIRED`, `REVOKED`. Sağlayıcının ham durumu, faturalama retry durumu, `auto_renew_enabled`, planlanan değişiklik ve `paid_through/valid_until` ayrı tutulur. **Yenilemenin kapatılması bugün erişimin bitmesi değildir.** Ödeme denemesi başarısızken sağlayıcının tanıdığı geçerli süre/grace ayrıca değerlendirilir; tek hata event’iyle geçmiş ve erişim silinmez. Her kanalın mapping’i contract testleriyle belirlenir; duruma isim vermek API yeteneği kanıtı değildir.

Paket hakları ve kullanım limitleri DB’de sürümlüdür. API/worker plan üretimi başlarken ve ücretli kaynak kullanmadan önce etkin hakkı/kotayı kontrol eder; istemcinin `premium=true` alanına güvenmez. Paralel işler kota rezervasyonuyla çift kullanım yaratmaz; sistem kaynaklı başarısızlıkta kota politikası açık ve tutarlıdır. BYOK kullanımı sağlayıcının kullanıcıya kestiği ücretle, platform LLM maliyeti ve Sportapp üyelik bedeliyle karışmaz. Sağlayıcının harcamasına dair veri yoksa “bilinmiyor/tahmini” etiketi kullanılır.

Erişim sonlandığında yeni ücretli üretim policy’ye göre durabilir; eski reçete/geçmiş, izin yönetimi, destek, hesap kurtarma, silme ve kendi verisini alma sırf ödeme yapılmadığı için rehin tutulmaz. Hesap silme/askısı mağaza aboneliğini kendiliğinden bitirmez; kullanıcıya mağazadaki yönetim ve etkiler açıkça gösterilir. Sağlayıcı abonelik iptalini desteklemiyorsa admin düğmesi başarı taklidi yapmaz. Bir admin üyelik kaydını düzeltmek için sağlık kaydını, antrenman önerisini veya geçmiş ödeme tutarını değiştiremez.

### 9.8 Para olayları, doğrulama ve mutabakat

**P0 veri akışı:** Seçili kanalın doğrulanmış bildirimi/sorgusu → tekrar korumalı `BillingProviderEvent` inbox → transaction/financial event kaydı → güncel hak hesabı → iPhone ve admin özeti → gerekiyorsa servis bildirimi. İşlem kimliği ve ortam, mükerrerliği engelleyen unique anahtara dahildir. Aynı olay önce istemciden, sonra webhook’tan gelirse tek işlem olur. Webhook ancak doğrulanıp dayanıklı kayıt alındıktan sonra başarılı cevaplanır; ağır iş worker’da sürer.

Apple yolunda resmî sunucu kütüphanesi veya eşdeğer doğrulanmış uygulama kullanılır: imzalı veri, sertifika/ortam/bundle/app/ürün ve işlem kimliği kontrolleri; API anahtarları yalnız sunucuda; notification doğrulama ve transaction history sorgusu. İlgili sürümün destek/bağımlılık şartları pinlenir. Sağlayıcının eski örnek runtime minimumunu üretim runtime tercihi diye kopyalama. [S55]

`appAccountToken` gibi desteklenen hesap bağlama alanı kişisel e-posta değil uygulamaya özgü rastgele kimlikle eşlenir. App Store hesabı ile Sportapp hesabı aynı kimlik kabul edilmez. Satın alma başladıktan sonra logout veya A→B hesap geçişinde geç callback B’ye erişim vermez. Daha önce A’ya bağlanmış işlemi B’de geri yüklemek otomatik taşıma değil `OWNERSHIP_CONFLICT`/destek akışıdır; işlem tek kez sayılır ve hesaplar sessizce birleştirilmez. Family Sharing desteklenecekse ayrı ürün/sağlayıcı politikası gerekir; P0’da varsayılmaz.

Olay geliş sırası gerçek olay sırası değildir. Eski bir renew bildirimi refund/revocation’ı silemez; zaman, transaction zinciri ve gerektiğinde yetkili güncel sağlayıcı sorgusu kullanılır. Kaçan/boş/geç bildirimde cursor/sayfalama/rate-limit uyumlu yeniden sorgu vardır. Eşleşmeyen işlem kaybolmaz: sınırlı `UNMATCHED` kuyruğu, kaynak/ref ve sorumlu görünür; kullanıcı eşleştirmesi delil ve yetkiyle yapılır. Tam ham payload yalnız gerekli korumalı teknik saklama süresince tutulur; genel loga dökülmez.

Tutar modeli `currency`, `raw_amount`, `raw_unit/scale`, normalize exact amount, tahsilat/olay tarihi ve varsa vergi/komisyon/sağlayıcı net ödemesi alanlarını ayırır. Kaynak birimi körlemesine `/100` yapılmaz. Farklı para birimleri varsayılan ayrı raporlanır; çevrim varsa kuru/kaynak/tarih/tahmini gösterilir. `0` gerçek sıfırdır; veri olmayan `null` alan sıfıra çevrilmez. Başarısız veya bekleyen tahsilat gelir değildir. Uygulama mağazası kesintisi doğrulanmadan sabit yüzde düşülmez.

İade talebi, sağlayıcının kabulü ve tamamlanan iade ayrı kayıtlardır. Sağlayıcının gerçek capabilities listesine göre eylem gösterilir. Kaynak işlemler salt okunur kökenlerini korur; yanlış manuel kayıt silinip üstü örtülmez, ilişkilendirilmiş ters kayıt/düzeltme ile izlenir. İşlem dengesinin hangi üyelik hakkını etkilediği sözleşmeye bağlıdır; bütün geçmişi veya diğer geçerli paketi otomatik iptal etmez.

Manuel ödeme/evrak kaydı desteklenecekse bu, BILLING-001’de izin verilmiş hizmet/kanal için `source=MANUAL`, delil referansı, tutar/birim, kayıt aktörü ve `UNVERIFIED → RECONCILED` geçişiyle yapılır. “Ödedi” kutusu seçmek tek başına doğrulanmış App Store işlemi oluşturmaz. Makbuz/fatura/sağlayıcı ödeme belgesi farklıdır; P0 yasal e-fatura üreticisi veya muhasebe defteri değildir.

### 9.9 Dashboard ve minimum CRM deneyimi

**İlk dashboard:** Dönem/tarih dilimi filtresi; yeni kayıt ve toplam doğrulanmış kullanıcı; açık tanımlı son 7/30 gün kullanıcı aktivitesi; ücretsiz/ücretli/bedelsiz üyelik; yakında bitecek erişim; kanal ve para birimine göre başarılı tahsilat/iade; açık destek ve geciken takip görevleri. Her kart kendi filtrelenmiş listesine açılır. Son güncelleme ve veri kaynağı görünürdür; hesaplanan, tahmini ve eksik veri ayrı gösterilir.

Aktif kullanıcı, sağlık verisi eşitlenen kişi demek değildir: izinli ve içeriksiz uygulama kullanım olayının tanımı `METRICS_DEFINITIONS.md` içinde yer alır. Kayıt adedi `User` bazındadır; iki sosyal kimlik veya iki rol iki üye sayılmaz. Silinmiş/test personeli ve sandbox işlemleri üretim kartlarından ayrılır. Ücretli üye, ticari kaynağı doğrulanmış ve halen etkin erişime sahip kullanıcıdır; ücretsiz telafi ücretli üye sayılmaz. İki işlem aynı üyeye aitse kullanıcı adedi artmaz.

**Finans gösterimi:** Dönemdeki başarılı satış toplamı − dönemdeki doğrulanmış iadeler = iade sonrası işlem toplamı, aynı para birimi için gösterilir. Bu, muhasebeleştirilmiş gelir veya bankaya geçen net tutar değildir. Sağlayıcının fiilen aktardığı tutar varsa ayrı gösterilir; komisyon/vergi bilinmiyorsa kâr uydurulmaz. Aylar arası iade her iki olaya da referans verir. Dönemsel ürün aktif değilse MRR/abonelik churn kartları yoktur; aktifse tanım ve kapsamıyla ayrı hesaplanır. Başarısız mağaza yenilemesi otomatik “tahsil edilecek borç” değildir; yalnız geçerli tahakkuk/alacak kaydı varsa açık alacak gösterilir.

**CRM kullanıcı kartı:** Hesap/iletişim → üyelik/ödeme özeti → görevler/destek → idari zaman çizelgesi. Kullanıcıyla görüşme notu, sorumlu personel, bir sonraki aksiyon ve son tarih yeterlidir. Etiket ve lifecycle durumu ticari/idari veriye dayanır; uyku, yorgunluk, nabız, hedef veya aktivite geçmişinden satış puanı çıkarılmaz. Etiket eklemek hak/rol değiştirmez. Notlar izinsiz AI özetine veya pazarlama servisine gönderilmez.

Destek kaydı `OPEN → IN_PROGRESS → WAITING_FOR_USER → RESOLVED → CLOSED` gibi basit durumlarla yönetilir. Yeniden açma ve yetkili atama vardır. iPhone’daki kullanıcı yalnız kendi talebini ve kullanıcıya açık yanıtı görür; iç not/etiket/audit görünmez. P0 mevcut işlemsel e-posta altyapısı veya uygulama içi yanıt kullanır; Gmail/WhatsApp senkronizasyonu gerektirmez. Not alma veya “arama yapıldı” yazma, gerçekten mesaj gönderildi/teslim edildi anlamına gelmez. Kullanıcı yanıtı ve admin notu sanitize edilir; e-posta/CRM içine gizlenen komut hiçbir finans veya rol işlemi başlatamaz.

### 9.10 CRM/finans saklama, hata ve kapsam yönetimi

Yeni kayıt event’i idempotent CRM kartı oluşturur. Hesap silme veya retention işlemi tamamlanmış kullanıcıya ait geç event kartı/üyeliği yeniden yaratamaz; minimal tombstone/silme iş kimliği kullanılır. Doğru hukuki dayanakla saklanması gereken asgari mali kayıtlar, silinen sağlık/CRM profilinden ayrılır ve erişimi daraltılır; bu durum bütün hesabı saklamak için gerekçe olmaz. Saklama süresi ve fatura yükümlülüğü ülke/satıcı/sağlayıcıya göre uzmanla belirlenir; uydurma sabit süre yoktur.

Export’ta filtre/scope/alanlar sunucuda doğrulanır. Finans yetkisi üyelerin sağlık export’unu açmaz. CSV içindeki kullanıcı notu/e-posta gibi alanların formül olarak yorumlanması engellenir; linkler özel, süreli ve indirende yeniden yetki kontrollüdür. CRM kayıtları sonradan sağlık tablosuna kopyalanmaz. Genel ürün aydınlatması idari destek/üyelik işlemesini açıklar; gerekli pazarlama izni ayrıca yönetilir ve P0’da kampanya motoru kurulmaz.

Destek/finans/admin rolü iptal edildiğinde bir sonraki API’de ve bekleyen export/görevde yetki yeniden değerlendirilir. Panelde rol düğmesini kaldırmak yeterli değildir. Normal planlama LLM araçlarına billing/admin write yetkisi verilmez. Kritik retry/ayar değişikliğinde önizleme, gerekçe, sürüm ve audit kullanılır; geçmiş antrenman veya gerçek ödeme kayıtları CRUD kolaylığı için silinmez.

## 10. Özellik listesi — AI ve kullanıcıya ait API bağlantısı

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| AI-01 | P0 | Platform LLM bağlantısı | Ürün sahibinin LLM servisine yapılandırılabilir bağlantı; model adı kod içine gömülmez. |
| AI-02 | P0 | BYOK | Kullanıcı desteklenen servise ait API anahtarını ekler, test eder, seçer, yeniler veya siler. |
| AI-03 | P0 | Custom endpoint | Güvenlik kontrolünden geçen HTTPS OpenAI-compatible endpoint ve model tanımı. |
| AI-04 | P0 | Ortak sağlayıcı adaptörü | İç istek/yanıt sözleşmesi sağlayıcıdan bağımsızdır. |
| AI-05 | P0 | Yetenek testi | Structured output, tool calling, context/output bütçesi ve desteklenen görevler doğrulanır. |
| AI-06 | P0 | Görev bazlı AI kullanımı | İlk haftayı oluştur, haftayı değerlendir, seansı uyarla, değişikliği açıkla, doğal dilden veri çıkar. |
| AI-07 | P0 | Yapılandırılmış çıktı | Model yanıtı şema ve alan/ilişki kontrollerinden geçer; serbest yazı doğrudan plan olmaz. |
| AI-08 | P0 | Ortak antrenman kontrolleri | Kullanıcı modeli de platform modeliyle aynı erişim, plan ve güvenlik sınırlarından geçer. |
| AI-09 | P0 | Veri paylaşım onayı | Sağlayıcı, endpoint, amaç, gönderilecek veri türleri ve otomatik çalışma izni gösterilir. |
| AI-10 | P0 | Hata ve fallback politikası | Başka modele veya sağlayıcıya sessiz aktarım yok; son onaylı plan ve açık hata durumu. |
| AI-11 | P0 | Kullanım ve bütçe | Token/istek/gecikme, bildirilen kullanım, tahmini maliyet ve otomatik iş limitleri. |
| AI-12 | P0 | Sağlayıcıdan bağımsız hafıza | Profil, tercihler, hedefler ve planlar uygulama DB’sinde; model sohbet oturumuna bağımlılık yok. |
| AI-13 | P0 | Bağlam oluşturucu | İzinli, ilgili ve güncel bilgiyle sınırlı özet; bütün ham geçmiş her isteğe eklenmez. |
| AI-14 | P1 | Ek yerel protokoller | Anthropic/Gemini gibi istenen servislerin native API adaptörleri; gerçek uyumluluk testine bağlı. |
| AI-15 | P1 | Antrenör/kurum AI bağlantısı | Ayrı hesap sahipliği, harcama ve sporcu veri izniyle. |
| AI-16 | P2 | Yerel cihaz içi çıkarım | Ayrı performans ve gizlilik değerlendirmesi; P0 için varsayım değildir. |

### 10.1 Sağlayıcı modları

**PLATFORM_DEFAULT:** Platform yöneticisinin tanımladığı kendi LLM servisi. Sunucu içi adresler yalnızca yönetici tarafından, ayrı ağ politikasıyla kaydedilebilir.

**USER_BYOK:** Kayıtlı ve desteklenen sağlayıcıya kullanıcının API anahtarıyla erişim. Anahtar başka kullanıcı veya antrenör işinde kullanılamaz.

**USER_CUSTOM_ENDPOINT:** Kullanıcının verdiği ve güvenlik kontrolünden geçen kamuya açık HTTPS endpoint. Bu modda backend’in kendi localhost’u, şirket içi IP’ler veya bulut metadata servisleri erişilebilir değildir. Kullanıcının bilgisayarındaki localhost, backend’den aynı bilgisayar anlamına gelmez.

**ORG_CONNECTION (P1):** Kurumun yönettiği bağlantı; yalnızca ilgili sporcu/veri kapsamı izinliyse.

OpenAI-compatible bir başlangıç ortak protokolüdür; bütün API özelliklerinin eşdeğer olduğunu ifade etmez. Ollama bu API’nin bir alt kümesini desteklediğini belirtir; vLLM de uyumluluk ve model bağımlı özellikler tanımlar. Bu nedenle endpoint protokolü ve model yeteneği ayrı test edilmelidir. [S5] [S6]

### 10.2 AI bağlantı ekranı ve veri modeli

Kullanıcı şunları yönetebilir: mod, sağlayıcı adı, güvenli base URL, model kimliği, maskeli API anahtarı, desteklenen görevler, bağlantı test sonucu, son doğrulama, otomatik üretim izni, kullanım limiti ve fallback tercihi.

`AIConnection` alanları en az:

`id`, `owner_type`, `owner_id`, `provider_type`, `protocol`, `base_url`, `model_id`, `credential_ref`, `capability_profile_id`, `allowed_tasks`, `data_policy_id`, `status`, `last_tested_at`, `created_at`, `updated_at`.

`credential_ref` kasadaki anahtarın referansıdır. Açık anahtar veritabanı sorgularında, API cevaplarında, hata mesajlarında, LLM bağlamında veya telemetride görünmez.

Bağlantı testi sentetik, sağlık verisi içermeyen isteklerle başlar. Model listesi endpoint’i yoksa test edilmiş manuel model kimliği kabul edilebilir. Anahtar doğru olsa bile haftalık plan görevinde güvenilir çıktı üretemeyen model, o görev için uygun sayılmaz.

### 10.3 Kullanıcı sağlayıcı seçimi yalnızca sohbet için değildir

Seçilen model, izin verilen kapsamda haftalık plan taslağı ve adaptasyon görevlerinde de kullanılmalıdır. “Kendi AI’ını bağladın” gösterilip bütün planların gizlice platform modelinde üretilmesi kabul edilmez.

Model belirli görevi desteklemiyorsa bunu açıkça göster. Kullanıcı izin verirse görev bazlı başka bağlantı seçilebilir. Yeni sağlayıcıya geçiş sağlık verisi aktarımını değiştiriyorsa ayrıca geçerli izin gerekir.

Model değişimi önceki planı otomatik yeniden üretmez. Mevcut yapılandırılmış geçmiş korunur; gelecek görevler yeni bağlantıyla yürür. Kullanıcı açıkça isterse yeniden değerlendirme taslağı oluşturulur.

### 10.4 Sağlayıcı seçiminden bağımsız çağrı sırası

1. Oturumdaki kullanıcı, sporcu kapsamı ve istenen görev doğrulanır.
2. Geçerli paylaşım izni, veri kaynaklarının kullanım hakları, bağlantı sahipliği ve harcama yetkisi kontrol edilir.
3. Yetkili ve yeterince güncel veri anı görüntüsü oluşturulur.
4. Bağlam bütçesine göre minimal bilgi hazırlanır; kritik kısıtlar kesilmez.
5. Seçilen model, ortak görev sözleşmesiyle çağrılır.
6. Çıktı şema, referanslar, aritmetik, plan kısıtları ve antrenman politikalarıyla kontrol edilir.
7. Geçerliyse öneri/taslak oluşturulur; yetkili onayı veya kayıtlı sınırlı otomasyon uygulanır.
8. Yayın öncesinde izin, veri ve plan sürümü tekrar kontrol edilir.
9. Karar özeti ve teknik kullanım kaydı güvenli biçimde tutulur.

Bir AI sağlayıcısı, antrenman kütüphanesini veya güvenlik politikalarını kendi cevabıyla değiştiremez. Başka bir modele “kontrol et” demek tek başına doğrulama değildir.

### 10.5 Structured output ve zayıf model davranışı

Desteklenen sağlayıcılarda şema kontrollü structured output/tool calling kullan. Bu mekanizma çıktı biçimini kısıtlar; programın sportif açıdan uygunluğunu veya sayıların semantik doğruluğunu kanıtlamaz. Uygulama tarafındaki kontroller zorunludur. [S7]

Native tool calling yoksa ihtiyaç duyulan veriyi backend önceden hazırlayabilir ve sınırlı JSON taslağı isteyebilir. Şema hatası, model reddi, eksik cevap, bitiş limiti ve zaman aşımı ayrı hata türleridir. Sınırlı düzeltme denemesi yapılabilir; sonsuz retry veya maliyetli agent döngüsü kurulmaz.

Kapasitesi yetersiz bağlantı `UNSUPPORTED_FOR_TASK` olur. Bu durumda son onaylı plan gösterilir; güncel güvenlik durumu belirsizse geçmiş reçete yeni onay almış gibi sunulmaz. İlk plan henüz yoksa yalnızca uzman incelemesinden geçmiş, uygunluk koşulları sağlanan başlangıç şablonu veya manuel plan yolu sunulabilir; her kullanıcıya evrensel fallback antrenmanı verilmez.

### 10.6 Context ve kullanım yönetimi

Modelin ilan edilen maksimum context’i, çalışan endpoint’in gerçek konfigürasyonu olarak varsayma. Yetenek kaydında yapılandırılmış/ölçülmüş limit, input/output rezervi ve zaman aşımı olsun. Kritik kısıtlar sığmıyorsa sessiz truncation yapma.

Uzun geçmiş önce uygulamada deterministik olarak özetlenir. Yakın aktiviteler, mevcut hedefler, güncel kısıtlar ve ilgili performans verileri önceliklendirilir. Gerekirse hafta iskeleti ve seans ayrıntıları ayrı çağrılarda üretilir; sonunda tüm hafta birlikte doğrulanır.

Önbellek anahtarı en az sporcu, görev, yetki/izin sürümü, veri anı görüntüsü, plan sürümü, model/sağlayıcı ve politika sürümünü içerir. Başka sporcunun içeriği veya başka alıcının izin kapsamı cache üzerinden taşınamaz.

Gösterilen API maliyeti, fiyat ve usage güvenilir değilse tahmin olarak etiketlenir; sağlayıcının faturası olduğu iddia edilmez. Platformun çağrı bütçesi kesin sınırlandırılabilir; kullanıcının aynı API anahtarını başka yerde kullanmasının maliyeti bu uygulamadan kontrol edilemez.

### 10.7 Anahtar ve endpoint güvenliği

Anahtarlar sunucu tarafında secret manager/KMS gibi uygun kasa altyapısıyla korunur; mobil uygulamadaki oturum sırları Keychain benzeri güvenli saklama kullanır. Yetki minimumdur; döndürme, iptal, son kullanım ve erişim kaydı desteklenir. Anahtar sızdıran log/trace/hata yolu kabul edilmez. [S11]

Kullanıcı tanımlı URL’ler sunucu tarafı istek sahteciliği (SSRF) riski taşır. Public HTTPS endpoint modunda özel/loopback/link-local/metadata adresleri, IPv4/IPv6 varyasyonları, DNS rebinding ve yönlendirme kaçışları engellenir. Sınırlı portlar, TLS doğrulaması, yanıt boyutu, timeout ve kontrollü egress uygulanır. Sırf URL biçimi doğru diye güvenli sayılmaz. [S10]

Platformun kendi özel ağ LLM endpoint’i, kullanıcı tarafından tanımlanabilen endpoint’lerden farklı bir yönetici ve ağ politikasıyla çalışır. Kullanıcı keyfi header, proxy veya sistem promptu yoluyla bu sınırı aşamaz.

### 10.8 Sağlık veri bağlantısı ile AI bağlantısı farklıdır

`DataConnection`, dış sağlık uygulamasından hangi veri yoluyla okunduğunu; `AIConnection`, izinli bağlamın hangi modele gönderileceğini tanımlar. Kullanıcı Google Health verisini platformun kendi modelinde veya izin verdiği başka AI sağlayıcısında değerlendirebilir; veri markası model seçimini zorunlu kılmaz. Her durumda kaynak kullanım koşulları geçerlidir.

Sağlık uygulaması OAuth erişim/yenileme token’ları AI API anahtarı değildir. İki tür sır aynı alanlarda tutulmaz, istemcilere açık döndürülmez veya birbirinin yerine kullanılmaz. AI’ın dış uygulama hesabına keyfi giriş yapması ya da bağlı cihazlara erişmesi yasaktır.

LLM bağlamındaki her önemli olguya köken ve veri tarihi eklenir. Örneğin `imported_sleep_summary`, `user_reported_fatigue` ve `derived_training_load` ayrılır. “Son senkronizasyon 09:00” değerinden “09:00’da uyku ölçüldü” sonucu çıkarılamaz.

**Kimlik sınırı (v3):** Apple/Google login token’ı `AIConnection` credential’ı değildir. Kullanıcının kendi API anahtarını eklemesi sağlık verilerinin o servise paylaşım iznini açmaz. AI seçimi/recipient izni Bölüm 2.2 ve 6.10–6.15’teki ortak modelle değerlendirilir; LLM prompt’u bu yetkileri değiştiremez.

## 11. Çok sporlu katalog, hareket kütüphanesi ve karar motoru

### 11.1 Özellik listesi — Branşlar, kategoriler ve içerik yönetimi

| ID | Öncelik | Özellik | Gereksinim / kabul özeti |
|---|---|---|---|
| SPORT-01 | P0 | Genişletilebilir spor kataloğu | Koşu/kuvvet/HYROX sabit üçlüsü kaldırılır. Tek ve çok sporlu yetişkin kullanıcılar; yeni branş eklemek uygulama kodunda koşul çoğaltmayı gerektirmez. |
| SPORT-02 | P0 | Branş, varyant, yöntem ayrımı | Sport/variant, workout format, hareket, drill ve poz ayrı kavramlar; çoktan-çoğa ilişkiler. |
| SPORT-03 | P0 | Tam FIT sözlük aktarımı | Pinlenmiş resmî profildeki tüm `sport`, `sub_sport`, `exercise_category` ve `*_exercise_name` değerleri kayıpsız staging'e alınır; elle seçilmiş 20–50 kayıtla tamamlandı denmez. |
| SPORT-04 | P0 | Garmin menü adı katmanı | Resmî ürün kılavuzlarındaki aktivite adları/sinonimler FIT kodlarından ayrı tutulur; model/sürüm kanıtı olan kapsam raporu. |
| SPORT-05 | P0 | Marka bağımsız ek içerik | Fonksiyonel, HYROX, reformer Pilates gibi Sportapp kavramları resmî Garmin kodu uydurulmadan ayrı namespace ve provenance ile eklenir. |
| SPORT-06 | P0 | Branş bazlı deneyim | Koşuda deneyimli olan kullanıcı Pilates/yüzmede otomatik ileri seviye sayılmaz; beceri ve geçmiş branşa özgüdür. |
| SPORT-07 | P0 | Yarış dışı hedefler | Düzen, kondisyon, kuvvet, mobilite, teknik, eğlence ve ders devamlılığı; hedef tarih/süre ve nabız zorunlu değildir. |
| SPORT-08 | P0 | Kas bölgesi ve hareket örüntüsü | Kuvvette sırt/göğüs/omuz/kol/bacak/kalça/core ve alt gruplar; çekiş/itiş/squat/hinge/taşıma gibi ayrı filtreler. |
| SPORT-09 | P0 | Varyant ve ekipman modeli | Aynı hareket ailesinin barbell/dumbbell/kablo/makine/bant/vücut ağırlığı, tek/çift taraf, açı ve destek varyantları. |
| SPORT-10 | P0 | HIIT biçimleri | Interval, EMOM, AMRAP, Tabata, devre, süreye karşı gibi tipli bloklar; biçim etiketi tek başına gerçek yüksek yoğunluk kanıtı sayılmaz. |
| SPORT-11 | P0 | Fonksiyonel antrenman | Hareket örüntüsü, ekipman, amaç ve bileşik seans; yalnızca genel cardio etiketi değil. |
| SPORT-12 | P0 | Pilates | Mat/reformer/diğer aparat, pozisyon, seri, hareket amacı ve seviye; süre/tekrar/nefes döngüsü ve gerekiyorsa aparat ayarı. |
| SPORT-13 | P0 | Yoga | Stil/poz ailesi/pozisyon/akış; hazırlık, geçiş, tutuş ve uygun süre birimleri; kuvvet set şemasına zorlanmaz. |
| SPORT-14 | P0 | Mobilite ve esneme | Bölge, eklem, aktif/pasif, dinamik/statik, denge/kontrol; tıbbi tedavi iddiası yok. |
| SPORT-15 | P0 | Dayanıklılık branşları | Koşu, yürüyüş, bisiklet, yüzme, kürek ve diğer ergometrelerde ayrı varyant/teknik/seans şeması. |
| SPORT-16 | P0 | Takım/raket sporları | Branş, teknik/drill, maç/ders/serbest oyun, temas ve sabit randevu bağlamı; dakika koşuya körlemesine çevrilmez. |
| SPORT-17 | P0 | Dövüş/dans/gimnastik | Teknik/seri/round/koreografi gibi uygun bloklar; ileri ve uzman gözetimi gerektiren içerik ayrı yetki. |
| SPORT-18 | P0 | Doğa/kış/su/spesifik branşlar | Kaynak türünü kaybetmeden gösterme ve takvime yerleştirme; teknik koçluk için branş paketi ve güvenlik kapısı. |
| SPORT-19 | P0 | Uyarlanmış aktivite varyantları | Handcycle, oturarak/tekerlekli sandalye ve kişiye uygun alternatifler; hiçbir kullanıcıya varsayılan hareket kapasitesi dayatılmaz. |
| SPORT-20 | P0 | Karışık seans | Bir seansta birden fazla branş/blok; üst seans-alt parça ilişkisi, geçiş ve bir kere toplam yük/süre. |
| SPORT-21 | P0 | Branşa özgü doz şemaları | Süre, mesafe, tekrar, tutuş, nefes döngüsü, round, drill, aparat ayarı gibi tipli alanlar; uygulanamaz alanlar zorunlu değil. |
| SPORT-22 | P0 | Branşa özgü referanslar | Nabız/tempo/güç/RPE referansının branşı, kaynağı, tarihi ve geçerliliği; koşu referansı bütün sporlara kopyalanmaz. |
| SPORT-23 | P0 | Çok boyutlu yük değerlendirmesi | Uygun veri varsa ayrı cardio, kuvvet, darbe/temas, bölgesel ve beceri boyutları; çıkarım ölçüm diye gösterilmez. |
| SPORT-24 | P0 | Amaç koruyan alternatifler | Ortak kas grubu veya benzer kalori tek başına eşdeğerlik değildir; amaç, ekipman, beceri ve kısıt kontrolü. |
| SPORT-25 | P0 | Kaynaklar arası tür eşleme | Kaynak kodu/adı, Sportapp karşılığı, eşleme kalitesi, sürüm ve kayıp ayrıntı saklanır; belirsiz eşlemeye kullanıcı düzeltmesi. |
| SPORT-26 | P0 | Eksik hareket ayrıntısı | Kaynak yalnızca “Strength/Pilates/HIIT” özeti verirse hareket/set/tekrar uydurulmaz; plan uygulandı varsayımı yasak. |
| SPORT-27 | P0 | Katalogdan arama/seçim | Türkçe/İngilizce ad/sinonim; spor, alt tür, bölge, ekipman, amaç, seviye ve içerik durumuna göre arama. |
| SPORT-28 | P0 | Tercih/favori/yasak listeleri | Sevilen/istenmeyen spor ve hareket; sabit ders/maçlar, ekipman/erişilebilirlik tercihleri kullanıcıya göre. |
| SPORT-29 | P0 | İçerik yayın iş akışı | Ham import → sınıflandırma → taslak → inceleme → yayın; kaynak onayı ile egzersiz tekniği/politika onayı ayrı. |
| SPORT-30 | P0 | Antrenör özel içeriği | Kendi hareket/drill/şablonunu oluşturma, uygun onayla müşterisinde kullanma; global kütüphaneye sessiz yayın yok. |
| SPORT-31 | P0 | Sürümlü ve tekrar çalışabilir seed | Kaynak pin/hash, sayım, diff, çakışma, deprecated ve unknown davranışı; aynı import çift kayıt üretmez. |
| SPORT-32 | P0 | Geçmiş planların korunması | Katalog güncellemesi eski reçetenin adını/anlamını/kas grubu sürümünü değiştirmez; güvenlik geri çekimi ayrı olay. |
| SPORT-33 | P0 | Branş destek matrisi | Tanıma/içe aktarma/takvim/manuel plan/AI taslağı/otomatik uyarlama ayrı yetenek ve test kanıtı. |
| SPORT-34 | P0 | Branşa uygun içerik getirme | LLM'e tüm katalog değil, yetkili ve uygun alt küme; plan yalnızca geçerli içerik ID/sürümlerini referans eder. |
| SPORT-35 | P0 | Kaynak ve medya hakları | Sözlük/protokol, ad, Türkçe açıklama ve video/animasyon hakları ayrı; Garmin medyası izinsiz kopyalanmaz. |
| SPORT-36 | P0 | Dil ve anlam bütünlüğü | Resmî kod değişmez; TR/EN gösterim/sinonim ayrı, otomatik çeviri inceleme durumuyla; anlamdaş görünen hareketler otomatik birleşmez. |
| SPORT-37 | P0 | Aynı hafta farklı branşlar | Pilates + kuvvet + yüzme veya HIIT + tenis gibi kombinasyonlar hedef/kısıt/gerçek geçmişle planlanır; yalnızca koşu örnekleriyle test edilmez. |
| SPORT-38 | P0 | Katalog kalite raporu | Tür/kategori/hareket sayısı, tanınmayan/eksik metadata, rights/review ve branş yetenekleri ayrı raporlanır; sayı koçluk kalitesi kanıtı değildir. |
| SPORT-39 | P1 | Lisanslı görsel/medya | Yalnızca hakkı doğrulanmış veya özgün görsel/video; medya olmaması P0 metin tabanlı incelemenin yerine geçmez. |
| SPORT-40 | P1 | Yeni sürüm keşfi | Yeni resmî profil/kılavuz sürümünde inceleme önerisi ve diff; üretim kataloğu otomatik değişmez. |

### 11.2 Kavramsal model: tek bir kategori ağacı yeterli değildir

Kullanıcı arayüzünde ağaç gibi gezilebilir; veritabanı çoktan-çoğa ilişkileri destekler. Aynı squat hem kuvvet hem fonksiyonel hem HIIT seansında kullanılabilir. Pilates/yoga içinde de ortak hareket aileleri bulunabilir. Bir hareketin adı ortak diye uygulanış bağlamı, doz veya uyarlaması aynı sayılmaz.

| Kavram | Örnek | Ayrı tutulmasının nedeni |
|---|---|---|
| `SportFamily` | Dayanıklılık, kuvvet, zihin-beden, takım, raket | Kullanıcı gezinmesi ve genel içerik ailesi. |
| `SportDiscipline` | Koşu, yüzme, Pilates, tenis | Branşın profili, hedefleri, kuralları ve destek seviyesi. |
| `SportVariant` | Trail/treadmill; havuz/açık su; mat/reformer | Ortam, ekipman, beceri ve seans şeması farklılaşır. |
| `TrainingMethod` | HIIT, fonksiyonel, kuvvet dayanıklılığı | Birden çok branşta kullanılabilir; ayrı keşif ekranı olabilir. |
| `WorkoutFormat` | Sürekli, interval, devre, EMOM, AMRAP, akış | Blokların düzeni ve süre hesabı; sporun kendisi değildir. |
| `SessionPurpose` | Teknik, kuvvet, kapasite, mobilite, ders, yarış | Neden planlandığı ve alternatif seçiminin dayanağı. |
| `ContentItem` | Exercise, drill, pose, sequence, station | Tüm içerik “ağırlık kaldırma hareketi” değildir. |
| `MovementPattern` | Yatay çekiş, squat, hinge, rotasyon, taşıma | Biyomekanik/kullanım filtresi; kas haritasından ayrı. |
| `BodyRegion` / `MuscleGroup` | Sırt/latissimus, bacak/quadriceps | Çoklu birincil/ikincil/stabilizasyon ilişkisi. |
| `Equipment` | Dambıl, reformer, raket, havuz, sandalye | Ekipman adı, varyant, erişim ve gerekli ayarlar. |
| `SourceVocabularyEntry` | FIT spor kodu veya hareket kategori/kodu | Kaynağı kayıpsız korur; Sportapp ID'sinin yerine geçmez. |

HIIT ve fonksiyonel, kullanıcıya ayrı etkinlik seçeneği olarak sunulur; teknik modelde yalnızca bağımsız, ayrık “spor” enum'una hapsedilmez. Nabızdan ya da “EMOM” adından otomatik HIIT sınıflaması yapılmaz. HYROX da genel hibrit antrenmanla özdeşleştirilmez; yarış formatı ve istasyon kuralı gerektiğinde ayrıca sürümlenir. Buradaki sınıflandırma Sportapp ürün tasarımıdır; Garmin'in kendi resmî kas/kategori sınıflaması olduğu iddia edilmez.

### 11.3 Kategorili branş kapsamı

Aşağıdaki aileler kullanıcıya yönelik kanonik içerik tasarımıdır. Garmin'de doğrulanan karşılıklar kaynak eşleme tablosunda ayrıca belirtilir; bu tablo tek başına “her modelin tüm sporları” listesi değildir. Garmin'in resmî kılavuzlarında da model bazlı listeler ve birden fazla kategoride yer alabilen aktiviteler vardır. [S39][S40][S41]

| Aile | Branş/alt tür örnekleri | O branş içinde kategori/filtresi |
|---|---|---|
| Koşu | Yol, parkur, trail, ultra, koşu bandı, indoor track, sanal, engelli parkur | Kolay/sürekli, uzun, interval, yokuş, teknik, yarış/deneme; ortam ve beceri |
| Yürüyüş/doğa yürüyüşü | İç/dış mekân, treadmill walking, hiking, rucking, expedition | Süre/mesafe, eğim/arazi, taşınan yük, teknik/rekreatif |
| Bisiklet | Yol, MTB, gravel, BMX, cyclocross, indoor, commute/tour, eBike/eMTB, handcycle | Dayanıklılık, interval, sürüş tekniği, kadans; ortam/araç varyantı |
| Yüzme | Havuz, açık su; serbest, sırtüstü, kurbağalama, kelebek ve karışık çalışmalar | Stil, teknik drill, ayak/kol, sürekli/interval; havuz uzunluğu ve birimler |
| Kuvvet | Serbest ağırlık, makine/kablo, bant, vücut ağırlığı, calisthenics | Kas bölgesi, hareket örüntüsü, tek/çift taraf, ekipman, amaç, seviye |
| HIIT/kondisyon | Vücut ağırlığı, ergometre, karma ekipman, low-impact seçenekler | Interval, EMOM, AMRAP, devre, Tabata, süreye karşı; çalışma/dinlenme biçimi |
| Fonksiyonel | Squat, hinge, itiş, çekiş, taşıma, rotasyon, locomotion | Hareket örüntüsü, ekipman, düzlem, amaç; total-body ve bölgesel bloklar |
| Hibrit/çoklu spor | HYROX, karışık salon seansı, triatlon, duatlon, swimrun, brick | Branş sırası, istasyon, geçiş, yarış biçimi; üst/alt seans ilişkisi |
| Pilates | Mat, reformer, chair, Cadillac/tower, barrel ve küçük ekipman | Supine/prone/side-lying/seated/kneeling/standing; core, omurga hareketi, kalça, skapula, denge; temel/orta/ileri |
| Yoga | İlgili stil/akış, sandalye uyarlaması, ekipmanlı uygulama | Ayakta/oturarak/yerde poz; denge, katlanma, açılma, rotasyon, inversiyon; seviye/gözetim |
| Mobilite/esneme/denge | Bölgesel mobilite, dinamik/statik esneme, koordinasyon/denge | Boyun, omuz/skapula, torasik bölge, kalça, diz, ayak bileği; aktif/pasif ve pozisyon |
| Kardiyo/ergometre | Kürek, kayak ergometresi, eliptik, merdiven/floor climb, ip atlama | Sürekli/interval, teknik, süre/mesafe/tekrar; ekipman varyantı |
| Takım sporları | Basketbol, futbol, voleybol, hentbol, rugby, Amerikan futbolu, beyzbol/softbol, hokey, kriket, lacrosse, ultimate | Teknik/drill, taktik, maç, serbest oyun, kondisyon; branşa göre beceri |
| Raket sporları | Tenis, padel, squash, badminton, masa tenisi, pickleball, racquetball, platform tennis | Servis, vuruş, ayak çalışması, rally, maç, ders; partner/kort gereksinimi |
| Dövüş sporları | Boks, kickboks, karma dövüş ve ek branşlar | Teknik, gölge çalışma, torba/pad, kondisyon; temas/gözetim ayrı |
| Dans/gimnastik | Dans fitness, koreografi/teknik, barre, uygun temel gimnastik | Stil, seri, koordinasyon, denge, esneklik; ileri/akrobatik içerik onaya bağlı |
| Tırmanış/dağ | Indoor climbing, bouldering, sport climbing, mountaineering | Rota/problem, beceri, kavrama, genel hazırlık; teknik ve ortam güvenliği ayrı |
| Kış/paten | Alp disiplini, XC klasik/skate, snowboard, backcountry, snowshoe, buz/inline paten | Branş/ortam/teknik; genel hazırlık ile riskli teknik plan ayrımı |
| Su/kürek/yelken | Kürek, kano/kayak, SUP, sörf, kite/windsurf, wake türleri, su kayağı, yelken | Teknik, sürekli/interval, saha/su koşulu; ekipman ve gözetim |
| Golf/hedef/rekreatif | Golf, disc golf, okçuluk, binicilik ve diğer rekreatif aktiviteler | Teknik/drill, oyun/raunt, genel hazırlık; branşa özgü sınıflama |
| Uyarlanmış aktiviteler | Handcycle, oturarak kuvvet/kardiyo, tekerlekli sandalye varyantları | Ayrı kullanıcı “kutusu” değil, ilgili branşlara çapraz varyant; erişilebilirlik/ekipman |
| Nefes/meditasyon ve diğer kayıtlar | Normal nefes farkındalığı, meditasyon, gaming, motorlu spor veya diğer kaynak türleri | İlgili bağlamda tanıma/gösterme; hepsi otomatik fiziksel antrenman yükü sayılmaz |

**Eksik branş ekleme:** Katalogda görünmeyen spor/özel ders adı için `CUSTOM` taslağı, açıklama ve uzman incelemesi yolu bulunur. Kaynak türü bilinmiyorsa `UNMAPPED` saklanır; otomatik koşu/cardio'ya dönüşmez. İlerideki yeni Garmin/Apple/Google/Huawei/Samsung türleri için mobil uygulama yeniden yayımlanmadan yönetilebilen sürümlü katalog tercih edilir.

### 11.4 Kuvvet: kullanıcının istediği kas/bölge kırılımı

| Üst bölge | Alt kategori | Hareket ailesi örnekleri / ek filtre |
|---|---|---|
| Sırt | Latissimus, üst/orta sırt, trapez, bel ekstansörleri | Dikey/yatay çekiş, shrug, uygun ekstansiyon; barfiks, row, pulldown aileleri |
| Göğüs | Genel/üst/alt vurgu | Yatay/eğimli itiş, fly/adduction; press ve push-up aileleri |
| Omuz | Ön/yan/arka deltoid, rotator cuff ve skapular kontrol | Overhead press, lateral raise, reverse fly, rotasyon/stabilizasyon |
| Kol | Biceps, triceps, önkol/kavrama | Curl, extension, tutuş/taşıma; ekipman ve tutuş varyantı |
| Bacak | Quadriceps, hamstring, adduktor, baldır, tibialis | Squat/lunge, knee extension/flexion, calf/toe raise; tek/çift taraf |
| Kalça | Gluteal grup, abdüksiyon ve kalça stabilitesi | Hinge, bridge/hip thrust, abduction; yan/arka zincir varyantları |
| Core | Anterior, lateral, rotasyon/anti-rotasyon, anti-extension | Plank, carry, chop, rollout, uygun flexion/extension aileleri |
| Tüm vücut | Birden çok bölgeye yönelik | Olympic lift, Turkish get-up, thruster ve bileşik hareket; tek kas etiketine indirgeme yok |

Bu tablo klinik/anatomik ölçüm tablosu değildir; ürünün gezinme ve içerik etiketleme modelidir. Kesin kas yüzdesi, aktivasyon puanı veya “tam toparlanma saati” üretmez. `primary_muscles`, `secondary_muscles`, `stabilizers` çok değerli olabilir ve hareket bazında uzman incelemesi ister. Bir source kategorisinin altındaki bütün hareketlere aynı kasları körlemesine atama; isim veya Garmin kategorisi tek başına yeterli değildir.

**Örnek gezinme:** `Kuvvet → Sırt → Yatay çekiş → Kablo → Seated row`. Aynı içeriğe `Fonksiyonel → Çekiş` veya `HIIT → Karma devre` üzerinden de ulaşılabilir; yeni üç kopya egzersiz oluşturulmaz.

### 11.5 Diğer antrenman türlerinin iç kategorileri

**Pilates:** Uygulama türü (mat/reformer/aparat), vücut pozisyonu, hareket ailesi, amaç, seviye ve ekipman ayrı filtrelerdir. Hundred, roll-up, single-leg stretch, side-kick, bridge, reformer footwork gibi isimler içerik örnekleridir; bu belgenin verdiği kişisel reçete değildir. Reformer yay rengi küresel kilogram karşılığı değildir. Gerekli ayar, marka/model, mekanizma, inceleyen uzman ve belirsizlikle tutulur; farklı cihazın renklerini evrensel sayıya çevirme.

**HIIT/fonksiyonel:** Blok yapısı formatı, hareket kategorisi, ekipman ve amaçtan oluşur. `EMOM` dakika başına programlanan bloktur, bütün blok süreleri hesaplanır; `AMRAP` için planlanmış süre ve gerçekleşmiş tur sayısı farklıdır. Format adı yüksek yoğunluk gerçekleştiğini kanıtlamaz. Garmin'in açıklamaları da farklı HIIT biçimlerini ayrı tarif eder. [S44]

**Yüzme:** Stil, drill tipi, havuz/açık su, metre/yarda ve uygun blok hedefleri vardır. Kaynak sadece toplam süre veriyorsa stil/uzunluk sayısı ve teknik hatalar uydurulmaz. **Raket/takım sporları:** Vuruş/servis/pas/şut/ayak çalışması gibi branşa özgü drill, maç/ders ile birlikte modellenir; raket sporunu bacak kuvvet hareketleri listesine indirgeme.

**Yoga/mobilite:** Poz ailesi/eklem-bölge/akış ve seviye; tutuş süresi, taraf ve gerekiyorsa rahat nefes döngüsü alanları desteklenir. Her poz için nabız aralığı zorunlu değildir. **Dans/dövüş:** Seri/koreografi/round/teknik bağlamı vardır; kamera olmadan teknik doğruluk saptandığı iddia edilmez.

### 11.6 Garmin'den “tüm sporlar ve hareketler” gereksiniminin tam anlamı

Garmin ekosisteminde üç ayrı kapsam karıştırılmamalıdır:

1. **FIT protokol sözlüğü:** `sport`, `sub_sport`, `exercise_category`, tüm `*_exercise_name` sözlükleri; isim/kod/ilişki uyumluluğu için resmî ve makineyle işlenebilir başlangıç. Bu çalışma sırasında doğrulanan referans **FIT Python SDK 21.214.0**; resmî yayın tarihi **25 Ağustos 2026**. Kaynak sürümü ve erişim tarihi kaydedilir. [S37][S38]
2. **Saat menüsü/aktivite profilleri:** Model, yazılım ve bölgeye göre değişebilen kullanıcı adları; FIT'teki tek enum listesiyle birebir aynı değildir. Kılavuz başına kaynak izlenir. [S39][S40][S41][S42]
3. **Garmin Connect hareket içeriği/animasyonları:** Ad/kod bulunması açıklama, video, kas haritası veya özel programı yeniden yayımlama hakkı vermez. Kamuya açık sözlükte bulunmayan tam güncel Connect kataloğuna erişilmiş gibi davranma. [S43][S45]

**Tamlık kabul ölçütü:** Pinlenmiş profildeki ilgili her giriş staging'de veya nedenli hariç tutma raporunda yer alır. `unknown`, `generic`, `all`, `invalid`/sentinel ve kullanım dışı girişler kaynak bütünlüğü için korunur; uygulanabilir spor/hareket sayısını şişirmek için yeni egzersiz sayılmaz. `sub_sport` öğeleri her `sport` ile kartezyen çarpılıp sahte kombinasyonlar oluşturulmaz. Branş-alt tür ilişkisinin doğrulandığı mapping ayrıca tutulur.

`exercise_name` tek başına benzersiz değildir. Ana kaynak anahtarı `source_namespace + exercise_category_code + exercise_name_code`; kategori sözlüğünde karşılığı henüz bulunmayan isim sözlüğü de kaybolmadan ayrı namespace ile saklanır. Garmin kaynak ID'si hiçbir zaman Sportapp'ın evrensel egzersiz ID'si yapılmaz.

**Resmî FIT kategori adları**, yalnızca kaynak etiketleridir: bench_press, calf_raise, cardio, carry, chop, core, crunch, curl, deadlift, flye, hip_raise, hip_stability, hip_swing, hyperextension, lateral_raise, leg_curl, leg_raise, lunge, olympic_lift, plank, plyo, pull_up, push_up, row, shoulder_press, shoulder_stability, shrug, sit_up, squat, total_body, triceps_extension, warm_up, run, bike, cardio_sensors, move, pose, banded_exercises, battle_rope, elliptical, floor_climb, indoor_bike, indoor_row, ladder, sandbag, sled, sledge_hammer, stair_stepper, suspension, tire, run_indoor, bike_outdoor; ayrıca `unknown` işaretçisi. Bu liste incelenen sürüme aittir; importer listeden değil kaynağın kendisinden okur. `cardio_sensors` gibi kaynak adı Sportapp'a sensör ekleme talimatı değildir. [S38]

**Tam katalog çıktısı zorunlu geliştirme teslimatıdır:** `garmin_source_vocabulary.json`, `sportapp_catalog_seed.json`, `catalog_coverage_report.json` ve inceleme/gap raporu üretilir. Bu belge, Garmin Connect'in bütün hareketlerini, bütün model menülerini ve bütün Türkçe açıklamalarını elle çıkarılmış/onaylanmış hazır üretim veritabanı olarak sunmaz. Kamuya açık kaynakta doğrulanamayan öğeler açık kalır; kendi içerik veya lisanslı kaynakla tamamlanır. Herhangi bir sabit “1.600 hareket var, tamam” sayısı kabul kriteri değildir.

### 11.7 Tekrar üretilebilir içeri alma ve güncelleme hattı

```text
Resmî kaynak/version/erişim-hak kaydı
    → içerik hash'i ve ham sözlük snapshot'ı
    → tüm ilgili enum ve adların kayıpsız ayrıştırılması
    → source namespace + kodla idempotent staging
    → Sportapp branş/kategori/sinonim eşlemesi
    → hareket bazlı ekipman/kas/örüntü/doz zenginleştirme taslağı
    → hak + terminoloji + alan uzmanı incelemesi
    → içerik/politika sürümüyle yayın
    → kaynak diff'i, coverage raporu ve geri dönüş kaydı
```

LLM zenginleştirme ve TR/EN isim/sinonim önerisi yapabilir; `NEEDS_REVIEW` olur. Kaynaktan doğru okunmuş bir isim, doğru teknik açıklama veya doğru kas haritası onayı değildir. Çeviri orijinal `source_name` alanının üstüne yazılmaz. Uzman onayı olmadan placeholder kaslar/ekipmanlar “doğrulandı” sayılmaz.

Kaynak güncellemesinde added/renamed/deprecated/reclassified/removed değişiklikleri ayrılır. Yok olan kaynak kaydı geçmiş referansları silmez. İncelenen içerik üzerinde yeni kaynak import'u otomatik teknik/doz değişimi yapmaz. Fail/partial import aktif kataloğu yarım bırakmaz; staging atomik sürüm yayınıyla ayrılır.

**Bu belgeye eşlik eden yardımcı:** `Sportapp_Garmin_Catalog_Importer_v4.py` yerel `profile.py` içindeki sözlükleri kod çalıştırmadan AST ile ayrıştıran, sayım/provenance/review durumlarını üreten referans yardımcıdır. SDK'dan sensör modülü, decoder veya encoder çağırmaz. Ağ bağlantısı veya kaynak SDK kurulumu yapmaz; resmî sürüm dosyası ayrı sağlanır. Yardımcı scriptin testleri sentetik ve kaynak biçimine uyumlu örneklerdir; tam Garmin dosyası üzerinde üretim import'u yapıldığı veya tam kas etiketlemesi bitirildiği anlamına gelmez.

### 11.8 İçerik kayıt sözleşmesi

Her `ContentItem` şu mantıksal alanları destekler; boş/yok/uygulanamaz değerleri birbirinden ayırır:

- Kalıcı iç ID, içerik türü, sürüm, TR/EN isim, sinonimler, `source_refs`, `rights_status`, inceleme/yayın durumu.
- Branş/varyant/yöntem ilişkileri, hareket ailesi, örüntü, vücut pozisyonu, taraf, birincil/ikincil/stabilizatör kas etiketleri ve bunların inceleme kökeni.
- Ekipman ve ortam; minimum beceri/deneyim, ön koşullar, erişilebilirlik varyantları, profesyonel kısıt etiketleri.
- Doz şeması ve izinli birimler; uygulanabilir yoğunluk alanları, hareket açıklaması, teknik ipuçları, gerekli gözetim, regresyon/progresyon/alternatif ilişkileri.
- `classification_review_status`, `coaching_content_review_status`, `medical_claims_allowed=false`, `automatic_prescription_eligible`, kullanılabilir branş paketi ve politika sürümü.

Bu alanlar veri modelidir; her imported isimde hepsinin dolu olduğu iddia edilmez. Kaynak sınıflama için uygun ama reçete için yetersiz olabilir. Aynı hareketin daralan bir varyantı ayrı ID ya da açık varyant ilişkisidir; farklı tutuş/açı/yük koşulları anlam kaybıyla birleştirilmez.

### 11.9 Branşa özgü seans blokları ve süre/yoğunluk hesabı

`SessionBlock` ayrıştırıcı alanı olan tipli birleşimdir (`block_type` + `schema_version`). Uygulanamaz alanı sahte sıfırla doldurma; `not_applicable`, `unknown` ve gerçek sıfır farklıdır.

| Blok tipi | Plan alanları | Doğrulama örneği |
|---|---|---|
| `ENDURANCE` | Süre/mesafe, ortam, amaç; uygun referans varsa tempo/nabız/güç/kadans | Aynı blokta birincil hedef ve ikincil sınır ayrılır; km/m/yarda tutarlı. |
| `STRENGTH` | Hareket ID/sürümü, set/tekrar, yük modu, RPE/RIR, dinlenme, gerekiyorsa tempo | `kg total` ile `kg per hand`, ek vücut ağırlığı ile yardım ağırlığı farklı. |
| `INTERVAL_CIRCUIT` | Format, istasyonlar, rounds, work/rest, time cap, geçiş | EMOM/AMRAP/Tabata ayrı hesap; tur ve istasyon sayısı çarpımı doğrulanır. |
| `PILATES` | Hareket/seri, aparat/pozisyon/taraf; tekrar/süre/rahat nefes döngüsü, gerekiyorsa ayar | Yay/aparat ayarı evrensel kilogram değil; uygun inceleme olmadan atanmaz. |
| `YOGA_MOBILITY` | Poz/akış, taraf, tutuş/geçiş, amaç ve uygun ekipman | Akış ve tekrar grupları toplam süreyi iki kez saymaz; HR zorunlu değil. |
| `SWIM` | Stil/drill, tekrar, mesafe/süre, dinlenme; havuz/açık su bağlamı | 25 m havuz ile 25 yd havuz farklı; mevcut değilse uzunluk sayısı tahmin edilmez. |
| `SKILL_DRILL` | Branş, drill, tekrar/süre, partner/alan, seviye ve kalite odağı | Teknik yeterlilik sensör/video olmadan ölçülmüş gibi raporlanmaz. |
| `ROUNDS_SEQUENCE` | Round/seri sayısı, süre, ara, teknik/koreografi referansı | Dövüş/dans/gimnastikte branş yeteneği ve içerik onayı gerekir. |
| `FIXED_CLASS_MATCH` | Pilates dersi/maç/koçlu seans; randevu, amaç, tahmini süre ve kilit | AI ders içeriğini bildiğini veya organizatör programını değiştirdiğini söylemez. |
| `MULTISPORT_COMPOSITE` | Alt blok/branş, sıra, geçiş, üst seans ID | Üst toplam ile alt segmentler çift yük/aktivite oluşturmaz. |
| `GENERIC_SCHEDULED` | Tanınan ama derin koçluk paketi olmayan etkinlik | Takvim/uygunluk ve kullanıcı bilgisiyle ele alınır; uydurma teknik reçete yok. |

Hedef nabız, ölçülmüş nabız değildir. Pilates/yoga/kuvvet için sırf alan mevcut diye nabız hedefi yazılmaz. Koşu, bisiklet veya yüzmede kullanılan yoğunluk referansının branşı ve kaynak tarihi korunur. Kaynakta koşu VO₂max bulunması yüzme tekniği, Pilates seviyesi veya kuvvet kapasitesi çıkarımı için yeterli değildir.

**Süre hesabı:** Isınma, bloklar, dinlenme, taraf değişimi ve geçiş dahil edilir. Tekrarın gerçek süresi bilinmiyorsa tahmini süre ve aralığı gösterilir. “For time” geçmişte ölçülmüş sonuç değil, plan formatıdır; Sportapp kronometre başlatmaz. “AMRAP tur sayısı” gerçekleşen kayıt/beyan gelmedikçe bilinmez.

### 11.10 Destek seviyeleri ve P0 branş paketleri

Yetenekler ayrı alanlarla tutulur: `catalog_present`, `app_import_mapping`, `history_display`, `manual_schedule`, `structured_content`, `ai_draft`, `auto_adaptation`. UI'da kullanıcı için kısa destek etiketi bulunur; tek bir `supported=true` bütün yetenekleri temsil etmez. Kaynak uygulama bir branşı paylaşmıyor diye o branşın manuel planı kapanmaz.

**P0'da başlangıç/orta seviye genel fitness bağlamında çalışması gereken paketler:** Koşu/yürüyüş; kuvvet; HIIT; fonksiyonel; Pilates mat ve reformer için ayrı uygunluk/uzman inceleme kapıları; yoga; mobilite; bisiklet; yüzme; salon kardiyo/ergometre; hibrit/karışık seans. Her pakette ilk hafta, seans ayrıntısı, ekipman alternatifi, kısmi/kaçan seans, zaman değişikliği ve farklı branşla haftalık uyum senaryoları çalışmalıdır. İçerik/politika onayı yoksa paket henüz tamamlanmamıştır; yalnızca katalog adıyla yayımlanmaz.

**Diğer branşlar kapsam dışı değildir:** Katalog/aktarım eşleme/takvim/koç planı temel katmanı P0'dır; derin teknik AI koçluğu dal bazlı içerik ve kanıtla açılır. Takım, raket, dövüş, dans, tırmanış, kış ve su sporlarının her biri için geliştirme backlog'unda ayrı yetenek satırı, içerik açığı ve onay kapısı bulunur. Desteklenmeyen ayrıntı saklanmaz veya koşu planıyla taklit edilmez.

**Uzmanlık ve risk sınırı:** Dalış/dekompresyon/nefes tutma, yüksek riskli tırmanış, ileri akrobatik/inversiyon, yoğun temaslı teknik çalışma veya motorlu/taktik aktivite gibi türlerin katalogda tanınması otomatik teknik talimat üretme yetkisi değildir. Genel hazırlık ve randevu çevresindeki planlamayla teknik/güvenlik sistemlerinin görevleri ayrılır. Tıbbi rehabilitasyon, teşhis veya güvenlik cihazının yerini alma bu kapsam genişlemesiyle eklenmez.

### 11.11 Planlama ve adaptasyonun çok sporlu davranışı

Kullanıcı tek branş seçebilir; uygulama ona zorla koşu/kuvvet/HYROX hedefi açmaz. Karma kullanıcıda ilgili branşların gerçek geçmişi, sabit ders/maçları ve hedef ağırlıkları birlikte değerlendirilir. Bir haftaya yeni bir branş eklenince yeni başlayan seviyesi, yeni ekipman ve toplam zaman dikkate alınır.

Planlanan kas/hedef etkisi ile gerçekleşmiş yük ayrı kalır. Örneğin kaynak “45 dakika Pilates” diyorsa katalogda yüzlerce Pilates hareketinin bulunması hangi hareketlerin yapıldığını kanıtlamaz. Antrenör/kullanıcı içerik belirtirse bu bir beyan olarak ilişkilendirilir. Benzer şekilde “kuvvet” kaydı tek başına sırt/bacak set hacmi üretmez.

Çapraz branş analizinde ortak süre ve isteğe bağlı seans RPE'si gibi mevcut bilgiler kullanılabilir; türetilmiş yük formülü kaynak/method/version ile etiketlenir. Bütün sporları koşu kilometresi, TSS, kalori veya tek toparlanma saatine dönüştüren evrensel katsayı uydurma. Bölgesel/darbe/temas/teknik talepler veri ve inceleme izin verdiği kadar tahmin edilir; bilinmeyenler gizlenmez.

Alternatif seçiminde amaç, beceri, ekipman, kullanıcı isteği ve profesyonel kısıtlar birlikte kontrol edilir. Reformer dersi yerine otomatik koşu yazmak; yüzme tekniğini bisiklet süresiyle eşdeğer saymak; omuz rahatsızlığı bildiren kullanıcıya hareket adını değiştirip aynı talebi yüklemek uygun değildir. Çatışma varsa onaylı alternatif veya açık erteleme seçeneği sunulur; garanti iyileşme/performans iddiası yoktur.

### 11.12 Antrenör içeriği, haklar ve geçmişin taşınması

Antrenör branş uzmanlığını ve çalıştırdığı sporları belirtir. Rol sahibi olmak bütün sporlarda uzman kabul edilmek değildir. Antrenör panelinde branş destek/içerik açığı, kategori araması, hareket/doz editörü, sabit ders/maç ve değişiklik önizlemesi bulunur.

Özel egzersiz/şablon için `owner_scope=platform/coach/organization/athlete`, görünürlük, lisans ve inceleme durumları tutulur. Sporcu koç değiştirince yaptığı/planlanan seansın uygulanabilir metinsel snapshot'ı korunur; eski antrenörün bütün özel kütüphanesini yeni antrenöre kopyalama yetkisi doğmaz. Lisanslı medya hakkı bitince geçmişin metinsel bağlamı kaybolmaz; medya erişimi ayrıca yönetilir. Kullanıcı bilgisi diğer sporcuların kütüphanesine veya embedding indeksine sızmaz.

### 11.13 Katı kısıtlar ve tercihler

Katı kısıtlar: geçerli güvenlik/profesyonel kısıtlar, zaman çakışmaları, mevcut olmayan ekipman, uygun olmayan aparat/beceri koşulları, yetkisiz içerik/medya, branş koçluk yeteneği, yayın yetkisi, kilitler, veri/AI/antrenör izinleri, şema/birim/katalog sürümü doğruluğu.

Tercihler: sevilen gün/saat/spor/hareket, egzersiz çeşitliliği, haftalık rutin, hedef önceliğine göre dağılım ve plan değişikliğini düşük tutma. Tercih bozulduğunda açıklama verilir; katı kısıtlar sessizce gevşetilmez. Ticari teklif veya komisyon uygun antrenman seçiminin puanını değiştiremez.

### 11.14 Kanıt ve sayısal sınırlar

Yük artışı, toparlanma aralığı veya yoğunluk için evrensel ve doğrulanmamış eşikler uydurma. Kullanılacak politikaları kaynak, popülasyon, branş, seviye, bağlam, sınırlılık ve uzman incelemesiyle kaydet. Klinik olay/sakatlık olasılığı üretmek P0 değildir. Ölçülmeyen teknik beceri veya kas yorgunluğu kesin veri gibi gösterilmez.

Kullanıcı geri bildiriminden kişiselleştirme yapılabilir; bir değişiklik sonrası iyi hissetmek o yöntemin nedensel etkisini kanıtlamaz. Öğrenme önce öneri kalitesi, uygulanabilirlik ve tekrar eden kullanıcı tercihlerini iyileştirir. Güvenlik sınırlarını otomatik öğrenmeyle genişletme. Kullanıcı verileri ve antrenör kararları varsayılan olarak model eğitimine gönderilmez; gelecekte ayrı çalışma yeni amaç/izin/hak/yönetişim gerektirir.

## 12. LLM görevleri ve araç sözleşmesi

LLM orkestrasyonu sınırlı ve izlenebilir olmalıdır. P0 için çok ajanlı karmaşık bir sistem veya ayrı bir araç protokolü zorunlu değildir; tipli uygulama servisleri yeterlidir. Harici sağlayıcıların kendi kalıcı agent hafızası ana kayıt sistemi yapılmaz.

| Görev | Girdi | Beklenen çıktı | İşlem yetkisi |
|---|---|---|---|
| `extract_profile_update` | Kullanıcı mesajı ve gerekli mevcut alanlar | Alan bazlı değişiklik taslağı, belirsiz alanlar | Onaylı profil servisi üzerinden |
| `draft_training_strategy` | Hedefler, geçmiş, uygunluk | Dönem amaçları ve varsayımlar | Taslak |
| `draft_weekly_plan` | Strateji, mevcut durum ve kısıtlar | Yapılandırılmış hafta ve seans adayları | Taslak |
| `draft_plan_adaptation` | Mevcut plan, yeni olgu, bağlam | Değişiklik seti ve kalan plana etki | Taslak |
| `explain_decision` | Doğrulanmış karar, olgular ve gerekçe kodları | Kullanıcıya anlaşılır açıklama | Yeni reçete/eylem ekleyemez |
| `review_training_week` | Plan-gerçekleşen farkı ve geri bildirim | Değerlendirme ve yeni hafta için öneriler | Doğrudan yayın yok |
| `prepare_coach_brief` | Paylaşılmasına izin verilen değişiklikler | Antrenör brifingi | Salt okunur |
| `answer_training_question` | Yetkili ilgili bilgi, incelenmiş içerik | Açıklama, gerekli olduğunda taslak işlem | Sohbetten yetkisiz plan değişikliği yok |

İç araçlar: `get_authorized_athlete_context`, `get_active_goals`, `get_availability`, `get_recent_activity_summary`, `get_current_plan`, `get_approved_workout_templates`, `search_training_catalog`, `get_sport_capabilities`, `get_content_item_version`, `get_discipline_constraints`, `validate_sport_session`, `get_policy_constraints`, `validate_plan_candidate`, `create_change_proposal`.

Araçtaki sporcu ve antrenör kimliği LLM’in yazdığı serbest ID’ye güvenilerek atanmaz; oturumdaki yetki kapsamıyla çözülür. LLM’e SQL, keyfi HTTP erişimi, anahtar okuma, politika değiştirme veya doğrudan `publish_plan` yetkisi verilmez. Yayınlama uygulama servisinde, geçerli onay ve sürüm kontrolüyle olur.

Kullanıcı mesajı, aktivite adı, antrenör notu, dış dosya ve araç yanıtı içindeki doğal dil güvenilmeyen içeriktir. “Önceki kuralları unut” gibi metinler veri olarak kalır; erişim veya gizlilik politikasını değiştiremez.

Bilgi getirme için önce yapılandırılmış sorgular ve gerekli metin araması kullanılır. Anlamsal arama gerçekten gerekiyorsa P1’de eklenebilir; sporcu verisini varsayılan olarak bir üçüncü taraf embedding servisine gönderme. Kütüphane kaynağı/sürümü ve erişim filtresi retrieval öncesinde uygulanır.

**Çok sporlu LLM sözleşmesi:** `draft_weekly_plan` ve `draft_plan_adaptation` girdileri seçili branşları, ilgili deneyimi, tipli blok şemalarını, kısıtları, yayınlanmış aday içerik ID/sürümlerini ve branş yetenek matrisini içerir. Katalog aracı kas/bölge, hareket örüntüsü, ekipman, seviye, pozisyon, stil/drill ve gerekli diğer filtreleri uygular. Büyük Garmin sözlüğü bütün olarak her prompt'a eklenmez. Kaynak/draft/unreviewed içerik otomatik reçeteye aday olamaz.

Model serbestçe yeni hareket ID'si, resmî Garmin kodu veya kas sınıflaması oluşturup yayımlayamaz. Yeni içerik önerisi ayrı review taslağı olabilir; global publish yetkisi yoktur. BYOK dahil bütün modeller aynı katalog, branş şeması, izin, scope ve politika kapılarına tabidir. Dış kaynak adları ve özel koç notları tool talimatı değil güvenilmeyen veridir; kaynak veya içerik izni retrieval'dan önce uygulanır.

## 13. Önerilen teknik yapı

Mevcut proje varsa önce kod, testler, servisler ve veri modeli incelenir. Sıfırdan başlanıyorsa referans yaklaşım:

**P0 iPhone:** Swift/SwiftUI + gerektiğinde UIKit uyumluluk katmanı; sporcu ve antrenör tek uygulamada. Salt okunur HealthKit, korumalı yerel saklama, çevrimdışı reçete ve beyan/aktarım kuyruğu. iPhone 12 ailesi alt test hedefidir; iOS tabanı Bölüm 1.6’daki açık karar ve Bölüm 13.7–13.12’ye göre yönetilir. Ölçüm SDK’sı veya watchOS hedefi yok.  
**P0 web admin:** TypeScript tabanlı responsive yönetim istemcisi; mevcut yapı uygunsa React/Next.js veya eşdeğer framework, sürüm seçimi D0’da. Kayıtlı kullanıcı/üyelik/ücret/CRM ve iç operasyon; ayrı personel oturumu/MFA, ortak API/RBAC, sağlık ve anahtar minimizasyonu. Halka açık tüketici sitesi veya ödeme checkout’u olarak varsayılmaz.
**P1 antrenör web:** İleride onaylanırsa aynı backend/kimlik üzerinden TypeScript istemci. İlk iOS yayınının koşulu değildir; P0 antrenör işlevleri native iPhone’dadır. P0 admin ile karıştırılmaz.  
**Backend:** TypeScript tabanlı modüler API; mevcut ekip/yapı uygunsa NestJS tercih edilebilir.  
**Veri:** PostgreSQL; kimlik, plan, izin ve audit için ilişkisel model.  
**İşler:** Dayanıklı iş kuyruğu ve ayrı worker; mevcut altyapı yoksa PostgreSQL tabanlı kuyruk veya gerekçeli ek kuyruk servisi.  
**AI:** Ayrı mantıksal gateway/adapter modülü; kendi LLM endpoint’i ve BYOK aynı iç sözleşmeden kullanılır.  
**Dosya ve sırlar:** Gerektiğinde özel obje saklama ve uygun secret manager.  
**Operasyon:** CI, sürümlü migration, güvenli telemetri, yapılandırılmış loglar ve geri dönüş planı.

Bu seçimler belirli bir kütüphane sürümünün güncellik garantisi değildir. Kullanılan sürümler geliştirme başlangıcında resmi belgelerle doğrulanır, pin edilir ve mimari karar kaydında yazılır.

İlk günden mikroservis, ayrı vektör veritabanı, veri gölü, fine-tuning hattı ve çok ajanlı çalışma zorunlu değildir. Modüller arasındaki sözleşmeler açık olmalı; dağıtım topolojisi ölçülen ihtiyaca göre genişletilmelidir.

### 13.1 Backend modülleri

`identity`, `auth-providers`, `sessions`, `account-recovery`, `onboarding`, `permission-policy`, `athlete-profile`, `goals`, `availability`, `app-data-connectors`, `source-registry`, `sync-orchestrator`, `activity-ledger`, `derived-features`, `check-ins`, `sport-catalog`, `source-taxonomy-import`, `taxonomy-mapping`, `discipline-capabilities`, `content-review`, `content-search`, `training-content`, `training-policy`, `planning`, `adaptation`, `session-guidance`, `coach-access`, `ai-gateway`, `consent`, `notifications`, `export-deletion`, `audit`, `operations`, `admin-access`, `admin-users`, `membership`, `entitlements`, `billing-catalog`, `payment-adapters`, `billing-inbox`, `reconciliation`, `crm`, `support-cases`, `admin-reporting`.

Antrenman karar motoru AI adapter sınıflarını doğrudan import etmez; ortak görev arayüzü kullanır. İstemci, sağlayıcıya özgü prompt veya gizli platform anahtarı taşımaz. İş kuralları iPhone, web admin, worker ve ilerideki antrenör web tarafında farklı kopyalar olarak çoğaltılmaz. Admin/billing/CRM modülleri mevcut modüler backend içinde başlar; ayrıca mikroservis, ikinci kullanıcı DB’si veya harici CRM zorunlu değildir.

### 13.2 Ana veri varlıkları

| Alan | Varlıklar | Önemli ilişki |
|---|---|---|
| Kimlik ve erişim | `User`, `AuthIdentity`, `ContactPoint`, `PasswordCredential`, `AuthTransaction`, `AuthSession`, `RefreshTokenFamily`, `StepUpGrant` | İç kullanıcı kimliği kalıcıdır; dış provider subject’i ve Sportapp oturumu ayrıdır. |
| Hesap ve başlangıç | `EmailVerificationChallenge`, `PasswordResetChallenge`, `OnboardingProgress`, `LegalAcknowledgement`, `SecurityEvent` | Sınırlı hesap/doğrulanmış hesap, koşul kabulü ve veri rızası aynı durum değildir. |
| Sporcu ve antrenör yetkisi | `AthleteProfile`, `CoachRelationship`, `AccessGrant`, `CoachInvitation` | Sporcu kimliği organizasyondan bağımsız; davet kabulü ve veri kapsamı ayrıca gerekir. |
| Hedef ve uygunluk | `Goal`, `GoalRevision`, `AvailabilityRule`, `AvailabilityException`, `EquipmentProfile` | Yerel zaman kuralı ve tekil istisna ayrılır. |
| Veri kaynakları | `DataConnection`, `ConnectionCapability`, `SourcePolicy`, `SyncCursor`, `SourceRecord`, `ImportedMetric` | Uygulama/yol/record kökeni, salt okunur yetki ve gözlenen kapsam korunur. |
| Gerçekleşenler | `Activity`, `ActivityRevision`, `SourceRecordLink`, `SessionMatch`, `UserActivityReport`, `CheckIn`, `WorkoutFeedback` | Kaynak kaydı ile kullanıcı beyanı ayrı; kanonik gerçekleşenler planın kopyası değildir. |
| Türetilmiş analiz | `DerivedFeature`, `DataCoverageSnapshot`, `NormalizationVersion` | Ham veriden ayrı; girdi kaynakları ve yöntem sürümü izlenir. |
| Spor sınıflandırması | `SportFamily`, `SportDiscipline`, `SportVariant`, `TrainingMethod`, `WorkoutFormat`, `SessionPurpose` | Tek enum yerine çoktan-çoğa gezinme, varyant ve yöntem. |
| Kaynak sözlüğü | `SourceVocabularyVersion`, `SourceVocabularyEntry`, `SourceTaxonomyMapping`, `CatalogImportRun`, `CatalogCoverageReport` | Namespace/sürüm/kod ve kategori+hareket kodu; hash, diff, kalite ve kaynak kanıtı. |
| Hareket/drill/poz | `ContentItem`, `ExerciseDefinition`, `ExerciseVariant`, `ContentSportLink`, `ContentTranslation`, `ContentReview`, `ContentLicense` | İçerik türü, TR/EN/sinonim, sahiplik, uzman/rights durumu ve immutable sürümler. |
| Filtreler | `BodyRegion`, `MuscleGroup`, `MovementPattern`, `EquipmentDefinition`, `ContentMuscleLink`, `ContentEquipmentLink` | Çoklu kas rolü; hareket örüntüsü, ekipman/aparat ve ayar şeması ayrı. |
| Branş yeteneği/politika | `SportCapability`, `DisciplinePolicyVersion`, `AthleteSportProfile`, `WorkoutTemplate`, `PolicyVersion` | Branş bazlı beceri, AI/manual/adaptation yetenekleri ve incelenmiş kurallar. |
| Plan | `TrainingStrategy`, `WeeklyPlan`, `PlanRevision`, `PlannedSession`, `SessionBlock`, `SessionContentSnapshot` | Branş/varyant/yöntem, tipli blok, içerik/politika/sözlük sürümü ve tarihsel snapshot. |
| Karar | `AthleteStateSnapshot`, `Recommendation`, `PlanChangeProposal`, `Approval`, `DecisionRecord` | Girdi sürümü ve yayın yetkisi. |
| AI | `AIConnection`, `CapabilityProfile`, `AITaskRun`, `UsageLedger` | Credential değeri değil secret referansı. |
| Gizlilik ve izinler | `ConsentGrant`, `ConsentEvent`, `PermissionDecision`, `SourceAuthorizationObservation`, `LocalHealthBinding` | Amaç/alıcı/kategori/tarih aralığı; gözlenemeyen OS izni ile ürün onayı ayrılır. |
| Operasyon | `AuditEvent`, `OutboxEvent`, `ExportJob`, `DeletionJob`, `ProviderRevocationJob`, `PushInstallationBinding` | Çıkış, izin iptali, hesap silme ve fiziksel iPhone’da hesap değiştirme ayrı yaşam döngüleridir. |
| Yönetim kimliği/yetki | `AdminStaffMembership`, `Role`, `Permission`, `RolePermission`, `AdminSession`, `AdminActionRequest` | Varsa mevcut RBAC yeniden kullanılır; User ilişkisi ayrı, MFA/audience/scope ve sürüm. |
| Ticari üyelik | `BillingProduct`, `PriceVersion`, `Membership`, `MembershipRevision`, `EntitlementPolicy`, `EntitlementGrant`, `EntitlementRevision`, `UsageReservation` | Paket/ücret/erişim/rol ayrı; ücretsiz varsayılan, fiyat geçmişi, ödeme yapan/yararlanan ve geçerlilik. |
| Ödeme ve mutabakat | `BillingCustomerLink`, `BillingProviderEvent`, `PaymentTransaction`, `FinancialEvent`, `RefundRequest`, `ReconciliationRun`, `BillingDocumentReference` | Sağlayıcı + environment + event/transaction kimliği; ham/normalize tutar ve ölçek; düzeltme/işlem bağı. |
| Minimum CRM | `CRMContact`, `CRMTag`, `CRMContactTag`, `CRMNote`, `CRMInteraction`, `FollowUpTask`, `SupportCase`, `SupportMessage` | User’a tekil kart, personel sahibi, iç not/açık yanıt, scope/retention; sağlık tablosunun kopyası değil. |

Bunlar mantıksal varlıklardır; hepsini düşünmeden ayrı tablo yapmak zorunlu değildir. Nihai ER diyagramı, unique kısıtlar, indeksler ve erişim sınırları D0/D1 çıktısıdır.

**Kimlik/izin veri bütünlüğü:** `AuthIdentity` için provider realm + doğrulanmış subject benzersiz; bir dış kimlik aynı anda iki kullanıcıya bağlanamaz. Token/kod tablolarında amaç, hesap, sona erme ve tek-kullanım kısıtları bulunur. `LocalHealthBinding` için etkin hesap/kurulum epoch’u; batch ve background job için `consent_version`/scope referansı zorunludur. Provider access/refresh token, parola ve AI anahtarı düz metin profil/veri tablolarında tutulmaz. Kimlik/izin kayıtları LLM bağlamına eklenmez.

Hesap sahibi işlem yapan kullanıcı ile verinin ait olduğu sporcu ayrıdır. `actor_user_id`, `subject_athlete_id`, `relationship/access_grant_id` ve amaç sunucuda doğrulanır; istemciye istediği `athlete_id`yi yükleyerek koç yetkisi kazanma imkânı verilmez. HealthKit batch’i sporcuya ait etkin yerel binding üzerinden alınır; koçun telefonundaki sağlık verisi müşteriye yüklenmez.

**Admin/finans/CRM veri bütünlüğü:** Bir kullanıcıya bir aktif CRM kartı; ticari erişim/grant versiyonlu ve idempotent; `(provider, environment, external_event_id)` ile `(provider, environment, external_transaction_id)` tekil. Provider transaction ile kanal müşterisi/hak sahibi eşleştirilmeden erişim açılmaz. Tek seferlik ürün ve yenileme transaction’ı ayrı; düzeltme olayı özgün tutarı ezmez. Money scale ve currency her satırda zorunludur. JSON/audit payload’larında kart, secret, gereksiz sağlık ve auth token saklanmaz.

**Yetkili görünüm:** Admin API, veri katmanındaki dar projeksiyonları kullanır; genel `User` veya `AthleteProfile` nesnesini komple serialize etmez. Alan/nesne/tenant izinleri controller, sorgu ve export/worker’a uygulanır. Fiyat yayımlama, üyelik hakkı verme ve mutabakat gibi işlemler optimistic concurrency + audit + outbox ile atomiktir. Apple/PSP signing secret’ı yalnız sağlayıcı adaptörü/secret manager erişimine açıktır.

### 13.3 Durum makineleri

Plan: `DRAFT → VALIDATING → NEEDS_APPROVAL → ACTIVE → SUPERSEDED / ARCHIVED`.

Başarısız taslaklar `INVALID`, `INFEASIBLE` veya `STALE` olarak ayrı açıklamayla tutulabilir. Mevcut aktif plan, başarısız yeni taslak nedeniyle silinmez.

Planlı seans durumu: `SCHEDULED`, `AWAITING_DATA`, `COMPLETED`, `PARTIAL`, `SKIPPED`, `CANCELLED`, `REPLACED`. Sportapp’a ait canlı kayıt/`IN_PROGRESS` sensör oturumu yoktur. `SKIPPED` ile `CANCELLED` farklıdır.

Kanıt durumu ayrı tutulur: `NO_EVIDENCE`, `USER_REPORTED_DONE`, `USER_REPORTED_PARTIAL`, `IMPORTED_MATCHED`, `CONFLICTING_EVIDENCE`. Tamamlandı kararı kullanıcının beyanına dayanıyorsa “dış kayıttan doğrulandı” yazılmaz. Geç gelen kayıt, beyanla uzlaştırılır.

Veri işi: `QUEUED`, `READING`, `UPLOADING`, `NORMALIZING`, `SUCCEEDED`, `PARTIAL`, `RETRYABLE_ERROR`, `REAUTH_REQUIRED`, `CANCELLED`, `BLOCKED_EXTERNAL`. Bağlantı sağlığı ayrı bir durumdur; boş batch başarısı veri kapsamı başarısı değildir.

Öneri: `PROPOSED → VALIDATED → PENDING_APPROVAL → APPLIED`; alternatif son durumlar `REJECTED`, `EXPIRED`, `STALE`, `FAILED`.

AI işi: `QUEUED`, `RUNNING`, `SUCCEEDED`, `VALIDATION_FAILED`, `PROVIDER_FAILED`, `UNSUPPORTED_FOR_TASK`, `CANCELLED`, `CONSENT_REVOKED`, `BUDGET_EXCEEDED`.

**Hesap:** `PROVISIONAL → ACTIVE → DELETION_PENDING → DELETED`; ayrıca `SUSPENDED`. Rol/sağlık izinleri bu durumdan ayrı değerlendirilir.

**Auth işlemi:** `INITIATED → PROVIDER_PENDING → VERIFIED → CONSUMED`; alternatifler `CANCELLED`, `EXPIRED`, `FAILED`. Amaç (`SIGN_IN`, `LINK_IDENTITY`, `STEP_UP`) değiştirilemez.

**Oturum:** `ACTIVE`, `REAUTH_REQUIRED`, `REVOKED`, `EXPIRED`. Oturum revoke işlemi yeni API çağrısında etkili olur; yalnızca istemci token’ını silmek yeterli değildir.

**Ürün izin kaydı:** `NOT_DECIDED`, `GRANTED`, `DECLINED`, `REVOKED`, `EXPIRED`, `SUPERSEDED`. Bunlar Sportapp’taki kullanıcının açık kararıdır; HealthKit’te gizli read izni için kullanılmaz.

**Kaynak izin gözlemi:** `NOT_REQUESTED`, `REQUEST_COMPLETED`, `USER_CANCELLED_IF_OBSERVABLE`, `ERROR`, `UNAVAILABLE`, `UNKNOWN_READ_ACCESS`; veri kapsama durumu ayrıca tutulur. Sağlayıcı gerçek kapsamı açıklıyorsa `GRANTED_SCOPES` ayrı kayıtlanır.

**Yerel sağlık bağlaması:** `UNBOUND → AWAITING_CONFIRMATION → ACTIVE → PAUSED / REVOKED`. Başka hesaba geçiş eski binding’i yeni kullanıcıya güncellemez, yenisini oluşturur.

**Hesap silme işi:** `REQUESTED → ACCESS_BLOCKED → REVOKING_PROVIDERS → PURGING → COMPLETED`; geçici hata `RETRY_REQUIRED`, hukuki saklama kapsamı `RETAINED_WITH_BASIS` olarak açıklanır. Hesaba yeniden giriş yapılabilen bir soft-delete tek başına tamamlanma sayılmaz.

**Admin personel:** `INVITED → ACTIVE → SUSPENDED / REVOKED`; MFA kaydı ve son OWNER koruması ayrı kontrol edilir. Rol iptali eski oturum/çalışan export hakkını devam ettirmez.

**Ticari paket:** `DRAFT → PUBLISHED → ARCHIVED`; satın alınmış fiyat sürümü immutable iş kaydıdır. `PUBLISHED` olmak mağazada satışa hazır olmakla aynı değildir; kanal `NOT_CONFIGURED / SANDBOX / READY / ACTIVE / DISABLED` olarak ayrı izlenir.

**Üyelik:** `FREE / TRIAL / ACTIVE / GRACE / EXPIRED / REVOKED`; sağlayıcı billing state, auto-renew tercihi ve pending plan değişikliği ayrı alanlardır. Ödeme: `PENDING / SUCCEEDED / FAILED / CANCELLED`; iade/geri alma ilgili ayrı finans event’leriyle türetilir, kaynak başarı kaydı silinmez. Hak: `SCHEDULED / ACTIVE / EXPIRED / REVOKED`.

**Billing event:** `RECEIVED → VERIFIED → APPLIED` veya `REJECTED / UNMATCHED / RETRY_REQUIRED`; gerçek imza/doğrulama olmadan VERIFIED yok. İade: `REQUESTED → PROVIDER_PENDING → CONFIRMED / DECLINED / FAILED`; desteklenmeyen eylem explicit `UNSUPPORTED_ACTION`.

**Takip görevi:** `OPEN / IN_PROGRESS / DONE / CANCELLED`; son tarih ve sorumlu ayrı. Destek kaydı: `OPEN / IN_PROGRESS / WAITING_FOR_USER / RESOLVED / CLOSED`. İç not ile kullanıcıya gönderilecek mesaj tür ve yetki olarak farklıdır.

### 13.4 Zaman, tekrar ve eşzamanlılık

Olaylar UTC zamanıyla ve gerektiğinde özgün IANA saat dilimi/offset bilgisiyle saklanır. Tekrarlayan takvim tercihi yerel zaman kuralıdır; salt sabit UTC saatine indirgenmez. Seyahat ve yaz saati uygulamaları gerçek süre hesabını bozmaz.

İçe aktarma, plan oluşturma, onaylama, bildirim ve seans kaydı idempotent çalışır. Worker tekrarları aynı planı iki kez yayımlamaz. Plan sürümü için optimistic concurrency kullanılır; eski sürüm üzerine gelen onay çatışma verir ve yeni fark gösterilir.

Dış uygulamadan aynı aktiviteye ilişkin art arda gelen kayıtlar kararlı batch olarak değerlendirilir. Her içe alınmış nabız örneği tüm haftayı yeniden üretmez; canlı sensör akışı yoktur. Plan yayını kendi başına sonsuz adaptasyon döngüsü başlatmaz.

### 13.5 Kaynak adaptörü sözleşmesi

Her adaptör aynı iç arayüze uyar; API adları örnektir, sağlayıcı endpoint’leri değildir:

```text
getCapabilities() -> veri türü / kapsam / izin gözlenebilirliği / destek kanıtı
requestReadAccess(scopes) -> yetkilendirme veya kurulum rehberi sonucu
readHistory(window, pageToken) -> kaynak kayıtları + sonraki sayfa
readChanges(cursor) -> upsert + varsa tombstone + nextCursor
getObservedCoverage() -> veri türü bazlı gözlenen aralık ve eksikler
getSyncHealth() -> son sorgu / son kabul edilen veri / hata
pauseConnection() -> Sportapp içindeki yeni okumayı durdur
revokeConnection() -> kaynak destekliyorsa token iptali + yerel bağlantıyı kapat
```

`readChanges`, webhook veya kesin `revoke` her kaynakta bulunmak zorunda değildir; destek yoksa açık yetenek sonucu döner. HealthKit’te OS izni uygulama içi bağlantı kesmeden ayrı olabilir; kullanıcıya OS ayarını nereden değiştireceği anlatılır.

Adaptörde `startWorkout`, `pairDevice`, `streamHeartRate`, `writeHealthData` veya `controlDevice` arayüzü bulunmaz. Google/Huawei için HealthKit köprü yolu, bu markaların SDK’sını ekleyen ayrı bir okuyucu değildir; aynı okuyucu üzerinde kaynak tanıma ve kurulum akışıdır.

Android Health Connect okuyucusu ancak ayrı kapsam onayıyla eklenir. iOS binary’sine Android SDK’sı koymaya veya Health Connect için var olmayan bulut endpoint’i üretmeye çalışma. Olası gelecekteki Android uygulaması da yalnızca uygulama deposunu okur; doğrudan donanım bağlantısı yapmaz.

### 13.6 Katalog bütünlüğü ve v3 geçişi

Kaynak girişi için `(namespace, source_version, vocabulary_name, numeric_code)` tekil olur. Hareket protokol eşlemesi gerektiğinde `exercise_category_code + exercise_name_code` birlikte kullanılır. `sub_sport` için ebeveyn ilişki kanıtı olmadan tüm sporlarla kartezyen kombinasyon üretilmez. Enum kontrol/unspecified değerleri korunur ama gerçek reçete hareketi gibi sayılmaz.

Kanonik içerik kimliği kaynağa bağımlı değildir; birden çok uygulama kodu aynı içeriğe doğrulanmış eşlenebilir. Her mapping relation/kanıt/inceleme bilgisi taşır. `owner_scope`, görünürlük ve içerik hakları aramada/önbellekte/AI araçlarında sunucuda uygulanır. Global kaynak sözlüğü kullanıcı sağlık kaydı değildir; kullanıcı özel içerik ve hedefleri global seed'e katılmaz.

v3 verisi varsa `sport_type` kayıpsız `source/raw legacy` alanıyla korunur, eşleme staging raporuyla kanonikleştirilir. Belirsiz eski kayıtlar unclassified kalır; eşleme için geçmiş seanslar silinmez. Her aktif/tarihsel plan eski içerik sürümü ve metinsel snapshot ile okunabilir. `ContentItem` güncellemeleri yayımlanmış geçmiş planı mutasyona uğratmaz. Güvenlik geri çekimi yeni atamayı durdurur, etkilenen gelecek planları incelemeye sevk eder; geçmiş silinmez.

Kaynak sözlüğü import'u, ürün backend'inin iOS'a SDK eklemesini gerektirmeyen build/admin görevidir. Şema ve veri geçişi testleri; tekrar seed, rollback, kullanıcı özel içeriği ve eski koç erişimlerinin korunmasını kapsar.

### 13.7 Native iOS mimarisi ve platform sınırları

Referans klasör/modül ayrımı: `AppShell`, `Authentication`, `Onboarding`, `AthleteWorkspace`, `CoachWorkspace`, `HealthDataReader`, `LocalStorage`, `SyncOutbox`, `Catalog`, `Planning`, `ConsentCenter`, `AISettings`, `Notifications`, `Networking`, `PlatformCompatibility`. Bunların her biri ayrı framework veya paket olmak zorunda değildir; sade, test edilebilir bağımlılık sınırları yeterlidir. Sağlayıcı SDK’sı UI ekranına yayılmaz; küçük adaptör ve protokollerle soyutlanır.

P0 için native Swift/SwiftUI referans alınır; sırf ileride Android olabilir diye Flutter/React Native veya gömülü webview kabuğuna dönüş yapılmaz. Mevcut repo farklıysa önce fark/yeniden kullanım/migration ADR’si çıkarılır; çalışan backend veya alan modeli sırf istemci değişiyor diye yeniden yazılmaz. `App`/scene yaşam döngüsü, giriş callback’i, foreground/background ve job geri yükleme birlikte tasarlanır. Uzun ağ/veri işlemleri ana thread’i bloke etmez; görünüm güncellemeleri uygun UI izolasyonunda olur.

`TARGETED_DEVICE_FAMILY=1` iPhone tasarım hedefini belirtir; iPhone 12’ye özgü mağaza filtresi değildir. iPhoneOS ve iPhone Simulator build hedefleri ayrı test edilir. watchOS/Wear OS hedefi, cihaz iletişim SDK’sı, egzersiz kaydı background modu veya sensör entitlements eklenmez. Mac/Catalyst ve optimize iPad/visionOS yayını bu fazın teslimi değildir; mağazadaki otomatik uyumluluk/dağıtım tercihleri yayın kontrolünde ayrıca incelenir. Desteklenmeyen platformda HealthKit yokluğu güvenli ele alınır.

Ağ işlemleri iPhone → Sportapp backend üzerinden ilerler; platform LLM ve kullanıcı API anahtarları mevcut gateway/sır kasası kurallarıyla backend’de kalır. Yapılandırılabilir LLM endpoint’i iPhone’un `localhost` adresi olarak yorumlanmaz. Geliştirmenin yerel test ayarları üretime kopyalanmaz; genel HTTP/sertifika doğrulaması kapatma veya LAN taraması eklenmez.

### 13.8 Geriye uyumluluk ve bağımlılık sözleşmesi

**Temel ilke:** Yeni SDK ile derlemek, yalnızca o SDK’nın iOS sürümünde çalışmak zorunda olmak değildir. `IPHONEOS_DEPLOYMENT_TARGET`, kullanılan SDK, Swift dil/derleyici sürümü, linked framework, üçüncü taraf minimum OS ve test runtime’ı ayrı kaydedilir. Üst sürüm API’leri `#available`/`@available`, uygun weak-linking ve erişilebilir alternatif akışla korunur; sadece düğmeyi gizlemek yetersiz olabilir, uygulama yükleme ve tip başlatma yolları da test edilir.

| Alan | P0 uyumlu tasarım | Kaçınılacak hata |
|---|---|---|
| Yerel kayıt | Onaylanan en düşük OS’yi destekleyen Core Data/SQLite tabanlı tek repository; sürümlü migration | SwiftData’yı koşulsuz temel yapıp eski OS’yi fark ettirmeden dışlamak. Apple SwiftData’nın iOS 17 ile geldiğini açıklıyor. [S52] |
| Navigation / state | En düşük sürümde çalışan navigation/state altyapısı; gerekirse UIKit veya eski SwiftUI uyumluluk bileşeni | Yeni navigation/Observation API’sini bütün ekranlara zorunlu yapmak; eski OS’de login sonrası boş sayfa. |
| Grafik ve görsel iyileştirme | Standart sayı/tablo veya uyumlu grafik görünümü; yeni grafik/animasyon API’si isteğe bağlı | Ana plan/onay bilgisini yalnızca yeni OS’ye özel bileşene koymak. |
| HealthKit türleri | Build SDK ve runtime’da mevcut türleri kuran typed capability registry; read-only query wrapper | Yeni aktivite enum’unu force-unwrap etmek, bilinmeyen türü varsayılan koşu saymak veya mevcut olmayan izni istemek. |
| Apple/Google login | Resmî native akış ve uyumlu SDK sürümleri; backend doğrulaması aynı | İki OS için iki bağımsız Sportapp hesabı yaratmak veya düşük sürümde güvensiz özel login formuna dönmek. |
| Bildirim/arka plan | Kullanılabilir OS API’leri; görünür güncellik, job durumu ve foreground yeniden deneme | Yeni arka plan API’si yok diye sağlık verisini sıfır/dinlenmiş saymak. |
| Yeni OS görselleri | İşlevi değiştirmeyen progressive enhancement | Yeni tasarım görünümü için minimum OS’yi izinsiz yükseltmek. |

**Somut bağımlılık kontrolü:** İncelenen Google Sign-In 10.0.0 sürüm notları geçişli AppAuth/GTMAppAuth değişimiyle iOS 15.0 tabanını; daha eski OS ihtiyacı için 9.2.0 kolunu belirtiyor. Bu bilgi sürüm seçimi girdisidir, eski kolun sonsuz güvenli bakımı veya iOS 14 dağıtımının çözüldüğü garantisi değildir. Seçilecek sürümün gerçek `Package.resolved`, geçişli bağımlılıkları ve güvenlik durumu D0/D1’de tekrar doğrulanır. [S51]

`IOS_DEPENDENCIES.md`: paket/SDK, sabitlenmiş sürüm, transitive minimum OS, amaç, lisans, privacy manifest/required-reason API, veri çıkışı ve review/test kanıtı. Paket güncellemesi OS tabanını, privacy davranışını veya cihaz kümesini değiştiriyorsa CI kapısı durur; ürün kararı ve regresyon gerektirir. Derlenmiyor diye otomatik iOS 17+ yapma.

### 13.9 Sürüme göre veri okuma, izin ve eşitleme

Her kaynak/yetenek için `source_app_version`, `source_min_os_if_known`, `os_version`, `sdk_min_api_version`, `available_read_types`, `observed_data_types`, `bridge_direction`, `checked_at`, `evidence_status` tutulur. Her değer mevcut/izinli/gözlenmiş ayrımını korur. OS türü desteklese bile ilgili veri gelmeyebilir; izin talebi tamamlandı diye bütün read yetkileri verildi kabul edilmez. Eski OS’de olmayan bir tür `UNAVAILABLE_ON_OS`; kaynağın paylaşmadığı tür `NOT_EXPORTED_BY_SOURCE`; henüz gözlenmemiş tür `NO_DATA_OBSERVED` olabilir. Kesin izin reddi gözlenemiyorsa bunu uydurma.

HealthKit yalnızca iPhone native adaptöründe okunur. Google/Huawei Apple Health köprüleri için Sportapp iOS desteğiyle kaynak uygulamanın güncel kurulum gereksinimi aynı sayılmaz. Kaynak uygulama yeni OS istiyorsa Sportapp’ın o telefonda çalışması hâlâ mümkün olabilir; ilgili kurulum rehberi sınırlı gösterilir, eski izinli kayıtlar/manual bağlam korunur. iOS’a Android Health Connect SDK’sı eklenmez. Samsung erişiminin doğrulanmamış olması bu iOS uygulamasını Android projesine dönüştürmez.

Eşitleme açılış/foreground, kullanıcının isteği ve OS’nin gerçekten sağladığı arka plan fırsatlarıyla sürer. Kilitli sağlık deposu okunamadığında `WAITING_FOR_PROTECTED_DATA`, ağ yoksa `WAITING_FOR_NETWORK`, uygun arka plan fırsatı yoksa bekleme/eski veri görünümü kullanılır. Bunlar otomatik “izin iptal” veya boş geçmiş değildir. HealthKit verisinin koruması/erişilebilirliği iOS güvenlik modeline bağlıdır; ölçüm oturumu açarak kilit kısıtını aşma girişimi yoktur. [S3][S53]

İlk büyük aktarım sayfalı ve sınırlı batch’lerle yapılır; yalnızca sunucu kabulünden sonra ilgili cursor ilerletilir. Uygulama kapanır/sonlandırılırsa tekrar deneme idempotent olur. Her batch hesap/installation epoch/izin sürümüne bağlanır. Sırf arka planda çalışmak için konum, ses veya workout recording açılmaz. Telefon açık kalmalı varsayımı yoktur; buna karşılık tam zamanlı eşitleme garantisi de yoktur.

### 13.10 Telefon içi veri, performans ve AI işleri

Kişisel cache, outbox ve sağlık özetleri dosya koruma ve hesap izolasyonuna tabidir; sırlar Keychain’dedir. Ham sağlık geçmişi App Group, varsayılan bulut senkronizasyonu veya loglarla başka yere kopyalanmaz. Gizlilik politikasıyla uyumlu yedekleme/restore kuralları, korumalı veri erişimi ve yeniden kurulumda eski credential/binding temizliği test edilir. Hesap değişiminde cache anahtarı yalnızca kullanıcı adını değiştirerek taşınmaz.

Katalog dosyasındaki bütün hareket ayrıntısı/medya başlangıçta RAM’e yüklenmez. Yerel indeks veya sayfalı arama, küçük özetler ve ihtiyaçta ayrıntı kullanılır. Garmin sözlük import’u telefonda SDK çalıştırma görevi değildir; server/build/admin içerik hattında yapılır. Büyük geçmiş işleme ile animasyonlar birbirini bloke etmez.

iPhone 12/12 mini için D0’da temsili veri hacmi ve ölçülebilir performans bütçeleri belirlenir; D5/D9’da cold/warm launch, son planın açılması, katalog arama, haftalık düzenleme, ilk/delta aktarım, bellek/enerji ve kötü ağ altında tekrar denenir. Bunlar kullanıcı fizyolojisinin ölçülmesi değildir. Backend/LLM bekleme süresi telefon render performansından ayrı raporlanır; sadece yeni Pro cihazın hız sonucu alt cihaz için kanıt sayılmaz.

AI işinde `job_id`, girdi sürümü, seçilen sağlayıcı ve izin sürümü sunucuda tutulur. Uygulama arka plana gitse bile backend işi politikasına göre sürebilir; iPhone açılınca aynı sonuca güvenli devam eder. Sonradan gelen sonuç yeni hedef/izin/plan sürümüyle çelişiyorsa stale olur. Kullanıcı iPhone 12 kullanıyor diye Apple Intelligence, cihazda LLM veya yeni nesil Neural Engine zorunluluğu konmaz. İnternet yokken son onaylı plan okunur; yeni sunucu AI çıktısı üretilmiş gibi gösterilmez.

### 13.11 Test matrisi ve araç zinciri

`IOS_SUPPORT_MATRIX.md` en az şu boyutları içerir: pazarlama modeli + doğrulanmış model kimliği, OS major/minor/build, o modele kurulabilirlik, ürün talebi, derleme hedefi, Xcode/SDK/Swift ve SPM lock hash, simulator/fiziksel ortam, kaynak uygulama sürümü/bölgesi, test grubu, test sonucu/tarih/artifact ve açık engel. Durumlar `REQUESTED`, `PROPOSED_BASELINE`, `SUPPORTED_TESTED`, `NOT_TESTED`, `BLOCKED_TOOLCHAIN`, `BLOCKED_TEST_ENV`, `NOT_INSTALLABLE`, `BETA_ONLY`, `DEPRECATED_WITH_DECISION` gibi açık anlamlarla ayrılır. Bu belgede hiçbir gerçek kombinasyon `SUPPORTED_TESTED` olarak işaretlenmiş değildir.

P0 doğrulama grupları: iPhone 12 ailesinde en düşük **onaylanmış** iOS kolu; küçük ekranlı mini; eski/orta OS kolları; güncel kararlı OS’de iPhone 12 ve yeni standart model; büyük ekranlı model; daha sonra çıkan küçük/SE/e gibi varyantlarda ilgili form faktörü. Ana sürüm kolları için temel akış smoke testleri ve en düşük desteklenen nokta sürümünde bağımlılık/API testleri gerekir. Her model × bütün tarihsel nokta sürümleri rastgele kartezyen çarpım yapılmaz; kurulabilir eşleşmeler, ana kol/kenar durum ve sürüme özgü hatalar kayıtlı risk-temelli matrise dağıtılır. Hiç test edilmemiş kol geçmiş sürüm desteği diye pazarlanmaz.

**Önemli araç ayrımı:** Kontrol edilen Xcode 27 satırı iOS 15 deployment tabanına rağmen cihaz/simulator desteğini iOS 17+ gösteriyor; Xcode 26 satırlarında daha eski test ortamı desteği bulunuyor. Bu, iOS 15 hedefi derlendiğinde aynı Xcode’un iOS 15 simülatör testi yapabileceği anlamına gelmez. D0’da ayrı eski-OS test runner’ı/uygun Mac veya gerçek cihaz dağıtım yolu planlanır. Araç tablosu değişebildiğinden sürümler CI’ya kaydedilir. [S46]

Release arşivi, eski OS testi için farklı araçla üretilmiş test binary’sinden ayrılır. Eski runner’da bir test derlemesinin geçmesi, mağazaya giden asıl imzalı arşivin o sürümde geçtiği kanıtı değildir. Uygun dağıtım yöntemiyle asıl aday binary mümkün olan gerçek eski OS cihazında doğrulanır; dağıtım/kurulum ortamı yoksa `BLOCKED_TEST_ENV`, “pass” değil. TestFlight’in kendisinin desteklediği OS aralığı ayrıca doğrulanır; her eski OS’de çalıştığı varsayılmaz.

### 13.12 Yayın, eski istemci ve sürüm bakım politikası

Dağıtım hedefi son onaylı destek kararından üretilir; uygulama hedefi, paket minimumları, gömülü frameworkler ve arşivdeki minimum OS uyumlu olmalıdır. iPhone aile hedefi, HealthKit capability ve salt okunur API çağrıları, Sign in with Apple, APNs/URL dönüşleri, privacy beyanları, gerekli neden API’leri ve imzalama/ortam ayrımı arşiv üzerinden kontrol edilir. App Store’un kabul ettiği SDK koşulu her yayında doğrulanır; geliştirici LLM’i güncel sürüm yerine eski prompt tarihini esas almaz. [S47]

Backend `client_build`, `api_contract_version`, `plan_schema_version`, `catalog_schema_version` ve desteklenen istemci yeteneklerini dikkate alır. Bilinmeyen branş/alan orijinal kod ve güvenli metinle korunur. Anlamı gösterilemeyen yeni bir seans bloğu sessizce atılıp plan onaylatılmaz; destekli temsil sunulur veya o düzenleme kontrollü engellenir. Uyum kontrolü yetki/izin kontrolünün yerine geçmez.

Bir OS kolu ileride kaldırılacaksa gerekçe, güvenlik/bakım etkisi, kullanıcı bildirimi, son destekli uygulama/API süresi ve veri çıkışı/silme kanalı belgelenir. Telefonun yükleyemeyeceği yeni sürüme sonsuz “güncelle” döngüsü kurulmaz. Gerçek güvenlik olayı yeni AI/upload işlerini gerekçeli kısıtlayabilir; hesap sahibinin gizlilik ve yardım yolları korunur. Gelecek beta sürümde çalışma taahhüdü yerine düzenli uyumluluk testi ve yeni kararlı sürümde yayın kararı bulunur.

### 13.13 Web admin ve ödeme adaptörü sınırları

Referans paketleme `apps/ios`, `apps/admin-web`, `services/api`, `workers` ve ortak şema/sözleşme paketidir; mevcut repo eşdeğer yapısı korunabilir. Ayrı web frontend deploy’u, ayrı domain/secret/auth cookie; tek otoritatif User/üyelik DB’si ve backend policy. Tarayıcıdan doğrudan production DB’ye, provider signing key’e veya sağlık deposuna erişim yoktur. SSR sunucu tarafında çalışsa da scope/authorization şartı kalkmaz. Ortam isimleri UI’da görünür; sandbox finans prod raporuna katılmaz.

Ödeme sağlayıcı adaptörü örnek iç arayüzü:

```text
getCapabilities() -> purchase/restore/status/refund/cancel/document/price-sync yetenekleri
verifyClientEvidence(payload, expectedAccountContext) -> doğrulanmış kaynak işlem veya hata
verifyNotification(payload, headers) -> doğrulanmış, ortama bağlı olay
fetchCurrentState(customerOrTransactionRef, cursor) -> yetkili güncel işlem/hak kanıtı
requestSupportedAction(action, validatedContext) -> pending/succeeded/unsupported/failure
```

Arayüz örneğidir, gerçek provider endpoint’i değildir. Bütün kanalların refund/cancel/fiyat değiştirme API’si olduğu varsayılmaz. Admin’in seçtiği eylem desteklenmiyorsa kullanıcı/sağlayıcı yönetimine yönlendirilir; manuel SUCCESS yazılmaz. Denetim ve sandbox kontrolleriyle ilk seçili kanalı uçtan uca doğrula; diğer adaptörleri boş mock olarak prod’a açma.

`GET /v1/me/entitlements` ve kullanım kararı backend otoritesindedir; native istemci desteklediği şema ile özeti gösterir. Ağ kesintisinde son onaylı plan ve veri hakları erişimi korunur; sınırsız yeni ücretli üretim için eski cache kullanılamaz. Eski iOS veya model seçimi farklı diye admin kaynaklı paket değişimi ölçüm/cihaz gereksinimi yaratmaz.

### 13.14 v5 → v6 geçişi ve geri dönüş

Eklemeli migration ile personel/RBAC, CRM ve ticari tablolar oluşturulur. Mevcut User kimlikleri, planlar, içerik sürümleri ve izinler korunur. Eski kullanıcıya açıkça `FREE`/mevcut hak eşlemesi yapılır; geçmişte ücret alınmış veya borç oluşmuş gibi transaction yaratılmaz. Eski hesaplarda admin/finans rolü otomatik oluşmaz. Var olan ödeme verisi gerçekten bulunursa kaynağı, ortamı ve deliliyle staging’e alınır; belirsiz kayıt inceleme kuyruğundadır.

CRM backfill ve yeni kullanıcı event’leri aynı unique/idempotency kurallarına uyar. Silme tombstone’ları backfill’de uygulanır. Eski native istemci yeni optional billing alanlarını tolere eder; platform API sürümü sessizce kırılmaz. Rollback, web/admin yazma ve yeni satışları güvenli durdurabilir; gerçekleşmiş para olaylarını/iadeleri veya erişim revocation’larını geri silmez. Sağlık izinlerini veya aktif spor planını eski üyelik şemasına dönmek için mutasyona uğratma.

## 14. API ve olay sözleşmeleri

Kesin yol adları mevcut API kurallarına uyarlanabilir; aşağıdaki işlevlerin karşılığı bulunmalıdır.

| API işlevi | Örnek yol | Kritik koşul |
|---|---|---|
| E-posta kayıt | `POST /v1/auth/register` | Minimum kimlik, koşul sürümü, hesap varlığını ifşa etmeyen hata; sınırlı doğrulama oturumu |
| E-posta doğrulama | `POST /v1/auth/email/verify`, `/resend` | Tek kullanım/süre/oran sınırı; GET önizlemesi işlem yapmaz |
| E-posta giriş | `POST /v1/auth/login` | Sunucuda parola doğrulama, risk/oran sınırı |
| Sosyal giriş işlemi | `POST /v1/auth/transactions` | Provider, istemci, amaç, nonce/state bağlamı; süreli transaction |
| Native sosyal giriş sonucu | `POST /v1/auth/providers/{provider}/complete` | Token/code doğrulama; doğrulanmamış e-posta veya provider ID ile hesap açılmaz |
| Tarayıcı sosyal callback — P1 | `/v1/auth/providers/{provider}/callback` | Sağlayıcının kayıtlı GET/POST akışı, state/CSRF ve exact redirect; ham token URL’de tutulmaz |
| Oturum yenileme | `POST /v1/auth/refresh` | Rotation/replay/eşzamanlılık; provider token ile karıştırma yok |
| Aktif kullanıcı | `GET /v1/auth/me` | Hesap/rol/onboarding özeti; sır veya sağlık payload’ı yok |
| Çıkış ve oturumlar | `POST /v1/auth/logout`, `GET /v1/auth/sessions`, `POST /v1/auth/sessions/revoke-all`, `DELETE /v1/auth/sessions/{id}` | Session sahipliği, sunucu iptali, yerel kuyruk/push temizliği |
| Parola sıfırlama | `POST /v1/auth/password/reset-request`, `/reset-confirm` | Genel yanıt, amaç-sınırlı tek kullanımlık token, eski oturum iptali |
| Parola/e-posta değişimi | `POST /v1/account/password/change`, `/email/change-request`, `/email/change-confirm` | Step-up, iletişim doğrulama ve güvenlik bildirimi |
| Giriş yöntemleri | `GET /v1/account/identities`, `POST /v1/account/identities/link`, `DELETE /v1/account/identities/{id}` | Mevcut + yeni kimlik doğrulama; çakışma ve son yöntem koruması |
| Hassas işlem doğrulaması | `POST /v1/auth/step-up` | Amaç/hedef/süre bağlı grant; sağlık rızası yerine kullanılamaz |
| Başlangıç ilerlemesi | `GET/PATCH /v1/onboarding` | Rol, aşama, devam konumu; API üzerinden koç erişimi açılmaz |
| Kimlik sağlayıcı bildirimleri | `POST /v1/auth/providers/{provider}/notifications` | Sadece desteklenen sağlayıcı olayları; imza, hedef ve replay kontrolü |
| Profil ve hedefler | `GET/PATCH /v1/athlete/profile`, `/v1/goals` | Alan yetkisi ve sürüm |
| Uygunluk | `/v1/availability/rules`, `/v1/availability/exceptions` | Zaman dilimi doğrulaması |
| iOS istemci uyumluluğu | `GET /v1/client-capabilities` | OS/istemci/API/katalog şeması için sürümlü uyum bilgisi; sağlık izni veya kimlik yetkisi oluşturmaz |
| Native kurulum durumu | `PUT /v1/installations/{installation_id}` | Hesap/kurulum epoch’una bağlı sınırlı sürüm ve push metadata; cihaz parmak izi veya sensör kaydı değil |
| Kaynak kataloğu ve kapsamı | `GET /v1/data-sources`, `GET /v1/data-connections/{id}/capabilities` | iOS desteği, aktarım yolu, gözlenen kapsam ve doğrulama seviyesi |
| Bağlantı yönetimi | `/v1/data-connections`, `/{id}/pause`, `/{id}/revoke` | Sağlık izinleri ile AI izinleri ayrı |
| Yerel HealthKit aktarımı | `POST /v1/app-data-sync/batches` | Etkin hesap/LocalHealthBinding + epoch + consent_version; kategori/kaynak/tarih filtresi, kayıt ID, batch sınırı ve idempotency |
| Uygulama hesap yetkisi — P1 | `/v1/data-connections/{provider}/authorize`, `/callback` | Resmî API, minimum scope, OAuth state/PKCE uygunluğu ve sır saklama |
| Kaynak webhook’u — P1 | `POST /v1/integrations/{provider}/webhook` | İmza/kimlik, tekrar/replay koruması, kaynağa özgü destek |
| Kapsam ve son veri | `GET /v1/data-coverage` | Metrik bazlı güncellik, kaynak ve bilinmeyenler |
| Kullanıcı aktivite beyanı | `POST/PATCH /v1/activity-reports` | Beyan kimliği, köken ve içe aktarılan kayda sonradan bağlantı |
| Kullanıcı bildirimi | `POST /v1/check-ins`, `/v1/workout-feedback` | Hassas veri sınırı |
| Strateji taslağı | `POST /v1/strategies/generations` | Yetkili AI route ve snapshot |
| Hafta taslağı | `POST /v1/weekly-plans/generations` | İdempotency; async job kimliği |
| Taslak sonucu | `GET /v1/jobs/{id}`, `/v1/weekly-plans/{id}` | İş sahibi / yetkili antrenör |
| Yayın | `POST /v1/weekly-plans/{id}/publish` | Sürüm, onay, güncel izin ve son doğrulama |
| Uyarlama | `POST /v1/adaptations`, `GET /v1/recommendations/today` | Güncel olgu ve plan ilişkisi |
| Onay/ret | `POST /v1/proposals/{id}/approve`, `/reject` | Yetki ve stale kontrolü |
| Seans reçetesi | `GET /v1/sessions/{id}` | Planlanan yoğunluk; canlı gerçekleşen değer değil |
| Tamamlama beyanı | `POST /v1/sessions/{id}/completion-reports` | Sensör kaydı değil; isteğe bağlı beyan |
| Plan/kayıt uzlaştırma | `/v1/session-matches`, `/v1/source-record-conflicts` | Kayıt kökeni korunur; kullanıcı/antrenör düzeltmesi |
| Antrenör bağlantısı | `/v1/coach-relationships` | Sporcu kabulü ve scope |
| AI bağlantısı | `/v1/ai-connections`, `/{id}/test` | Secret write-only; SSRF koruması |
| İzin açıklamaları | `GET /v1/permission-notices` | Amaç/alıcı/kategoriye göre güncel, sürümlü ve kullanıcı dilinde metin |
| İzin yönetimi | `GET/POST /v1/consents`, `POST /v1/consents/{id}/revoke` | Açık karar ve kapsam; çalışan/kuyruktaki işlere etki |
| İzin merkezi özeti | `GET /v1/permissions/summary` | Ürün rızası, kaynak gözlemi ve veri kapsamı ayrı; sahte HealthKit read granted yok |
| Yerel sağlık bağlaması | `POST /v1/local-health-bindings`, `POST /v1/local-health-bindings/{id}/revoke` | Aktif hesap, kurulum, sahiplik beyanı, epoch; OS izni vermez |
| Kaynak izin gözlemi | `POST /v1/data-connections/{id}/authorization-observations` | İstemci gözlemi OS izninin kriptografik kanıtı sayılmaz; backend kendi scope sınırını uygular |
| Sohbet | `/v1/coach-chat/messages` | Araç kapsamı; doğrudan yayın yetkisi yok |
| Taşınabilirlik | `/v1/exports`, `/v1/account/deletion` | Kimlik doğrulama, yaşam döngüsü ve audit |

**Katalog ve branş API'leri** aynı auth/tenant/rate-limit kurallarına tabidir:

| API işlevi | Örnek yol | Kritik koşul |
|---|---|---|
| Spor/varyant/yöntem listesi | `GET /v1/catalog/sports`, `/variants`, `/training-methods` | Yayınlanmış sürüm, dil ve uygun gezinme; kaynak enum ≠ tek kullanıcı listesi. |
| Hareket/drill/poz arama | `GET /v1/catalog/content` | Branş, bölge/kas, örüntü, ekipman, seviye, pozisyon/stil filtreleri; scope önce uygulanır. |
| İçerik sürümü | `GET /v1/catalog/content/{id}/versions/{version}` | Hak/inceleme/görünürlük; onaylı açıklama ve eski snapshot ile tutarlılık. |
| Branş destek matrisi | `GET /v1/catalog/sports/{id}/capabilities` | Catalog/import/manual/AI/adaptation ayrı; doğrulanmamış yetenek 'tam destek' sayılmaz. |
| Özel içerik taslağı | `POST /v1/coach/content-drafts` | Koç kimliği/sahiplik; özel taslak; otomatik global publish yok. |
| Kayıt türü düzeltmesi | `POST /v1/activities/{id}/classification-proposals` | Kullanıcının kayıt kapsamı ve sürüm; ham kaynak değişmez; inceleme/beyan kökeni. |
| Kaynak import ve kapsam | `POST /v1/admin/catalog/imports`, `GET /v1/admin/catalog/imports/{id}` | Yetkili admin, pin/hash/manifest; staging; dosya boyut/yapı sınırı. |
| İçerik inceleme/yayın | `POST /v1/admin/catalog/reviews`, `/releases` | Rol/branş inceleme/hak ve şema kapıları; atomik sürüm, audit/rollback. |

Ek olaylar: `catalog.import_completed`, `catalog.version_published`, `content.reviewed`, `content.withdrawn`, `sport.capability_changed`, `activity.classification_changed`. Kaynak güncellemesi kullanıcı verisini dışarı gönderme izni oluşturmaz; gelecekteki AI işlerinde alıcı/amaç izinleri yeniden değerlendirilir.

Uzun model işleri için API kabul yanıtı ile iş sonucu ayrılır. Arayüzde bekleme, iptal, tekrar deneme ve son onaylı planı kullanma durumları olmalıdır. Kesin saniyede model yanıtı vaat edilmez.

Olay örnekleri: `account.registered`, `identity.verified`, `identity.linked`, `identity.revoked`, `session.revoked`, `email.verified`, `onboarding.updated`, `consent.granted`, `consent.scope_reduced`, `local_health_binding.revoked`, `account.deletion_requested`, `source_record.upserted`, `source_record.deleted`, `import_batch.accepted`, `coverage.changed`, `canonical_activity.changed`, `checkin.recorded`, `availability.changed`, `goal.updated`, `plan.published`, `session_match.changed`, `completion_report.recorded`, `consent.revoked`, `coach_access.revoked`, `ai_connection.disabled`, `data_connection.paused`.

Güvenilir outbox/worker tasarımıyla veritabanı işlemi ve olay yayını arasındaki kayıp yönetilir. Olay payload’ına API anahtarı veya gereksiz ham sağlık içeriği konulmaz.

Backend’e veri yüklemek, dış sağlık uygulamasına yazmak değildir. Kaynak kaydını silme API’si sağlık uygulamasına delete komutu göndermez; Sportapp kopyasının saklama/işleme durumunu yönetir. “Şimdi eşitle” isteği de iPhone’un arka planda kesin çalışacağını garanti etmez; job durumu ve bilinen veri gösterilir.

**Auth/izin uçları için ek sınır:** Auth sağlayıcı seçimi ve read scope’lar server allowlist ile tanımlanır. İstemci `is_verified`, `role=ADMIN`, `permission=GRANTED` veya başka kullanıcının `athlete_id` alanını göndererek yetki yaratamaz. Sağlık kaynağının gerçek OS izni native tarafta; Sportapp backend işleme/erişim izni sunucudadır. `GET /permissions/summary` iPhone’un HealthKit deposunu uzaktan sorgulamaz.

Yetki hataları kimliği olmayan/expired oturum için 401, bilinen yetki eksikliği için 403 veya hassas nesne varlığını gizleme politikası; idempotency/versiyon çatışması için 409, rate limit için 429 gibi belgelenmiş semantikle dönülür. Public auth yanıtlarında hesap varlığı, yöntem ve hassas durumlar açık edilmez. Yetki reddi denetim kaydı içerik/sır sızdırmadan tutulur.

### 14.1 Web admin, üyelik ve minimum CRM API’leri

Yol adları örnektir; mevcut backend standardına uyarlanır. Bütün `/admin/` uçlarında aktif personel kaydı + MFA kapsamlı oturum + işlem/alan/scope yetkisi sunucuda doğrulanır. CRUD, mali olayları keyfî silme yetkisi vermez.

| API işlevi | Örnek yol | Kritik koşul |
|---|---|---|
| Admin giriş/davet/MFA | `/v1/admin/auth/session`, `/v1/admin/staff/invitations`, `/v1/admin/auth/mfa/*` | Halka açık admin kayıt yok; güvenli bootstrap ve kurtarma; normal user token yeterli değil |
| Personel/roller | `/v1/admin/staff`, `/v1/admin/roles`, `/v1/admin/permissions` | DB izinleri; son OWNER; privilege escalation ve wildcard yok |
| Dashboard | `GET /v1/admin/dashboard` | Tarih/para birimi/kaynak-güncellik, role göre kart ve filtre |
| Kullanıcı liste/kart | `GET /v1/admin/users`, `GET /v1/admin/users/{id}` | Sayfalı dar alan projeksiyonu; sağlık/secret/koç notu yok |
| Hesap işlemi | `POST /v1/admin/users/{id}/actions` | Allowlist eylem + reason + expected_version + step-up; suspension ≠ cancel billing |
| Paket/fiyat | `/v1/admin/billing/products`, `/{id}/prices`, `/{id}/publish` | Sürüm ve storefront mapping; gerçek mağaza fiyatı senkron olmadan satışa açma yok |
| Üyelik/grant | `GET /v1/admin/memberships`, `POST /v1/admin/entitlement-grants`, `/{id}/revoke` | Kaynak, süre, gerekçe ve rol; grant ödeme veya data consent değildir |
| İşlem/iadeler | `GET /v1/admin/billing/transactions`, `POST /{id}/supported-actions` | Sağlayıcı capabilities + step-up + idempotency; kaynak transaction PATCH/DELETE yok |
| Manuel referans | `POST /v1/admin/billing/manual-records` | Yalnız kanal kararı izinliyse; delil, UNVERIFIED durumu ve mutabakat |
| Mutabakat | `POST /v1/admin/billing/reconciliations`, `GET /{id}` | İzinli sınırlı job; stale/out-of-order olayları; provider rate-limit |
| Finans raporu/belge | `GET /v1/admin/billing/reports`, `GET /v1/admin/billing/documents/{id}` | Para birimi/tanım/scope; sağlayıcı belgesi, rastgele açık URL değil |
| Kullanıcı üyelik/hak | `GET /v1/me/membership`, `GET /v1/me/entitlements` | Yalnız kendi hesap; effective_at/schema/source durumu; role grant yok |
| iPhone işlem kanıtı | `POST /v1/billing/apple/transactions`, `/restore` | Seçili kanal; server verify + account ownership + environment; client tutarı güvenilir değil |
| Apple bildirimleri | `POST /v1/billing/webhooks/apple` | App Store signed notification doğrulaması; normal admin cookie değil provider kanıtı; dayanıklı inbox |
| CRM kart/etiket/not | `/v1/admin/crm/contacts`, `/{id}/tags`, `/{id}/notes`, `/{id}/interactions` | User tekilliği, izinli alan, yazan kişi, iç not ve auth kimliğinden ayrım |
| Görevler | `/v1/admin/crm/tasks`, `/{id}/assign`, `/{id}/complete` | Sorumlu/son tarih/durum ve optimistic concurrency |
| Admin destek | `/v1/admin/support/cases`, `/{id}/replies`, `/{id}/internal-notes` | Kullanıcıya açık yanıt ile iç not farklı route/izin; otomatik sağlık erişimi yok |
| Kullanıcı destek | `/v1/me/support/cases`, `/{id}/messages` | Yalnız kendi kayıt/yanıtları; iç not, diğer müşteri ve idari etiket yok |
| Operasyon/AI özeti | `GET /v1/admin/operations`, `GET /v1/admin/ai-usage` | Maskeli kaynak/görev/kota özeti; key/prompt/ham sağlık göstermeme |
| Admin export/audit | `/v1/admin/exports`, `GET /v1/admin/audit` | Alan/scope, export anında tekrar yetki, hassas veri azaltma, audit değiştirilemez UI |

Ek olaylar: `admin.staff_invited`, `admin.role_changed`, `admin.session_revoked`, `crm.contact_created`, `crm.task_due`, `support.case_opened`, `support.reply_published`, `billing.product_published`, `billing.event_verified`, `billing.transaction_recorded`, `billing.refund_confirmed`, `billing.reconciliation_completed`, `membership.changed`, `entitlement.changed`. Olay işleyicileri hesabın silinme/izin/rol durumunu yeniden doğrular; mesaj queue’su admin yetkisi kanıtı değildir. Finans idempotency anahtarı provider/environment kapsamını ve kaynak kimliğini içerir.

## 15. Ekran listesi ve UX gereksinimleri

### 15.1 Native iPhone — ortak hesap ve sporcu ekranları

| Ekran | Ana işlev | Zorunlu durumlar |
|---|---|---|
| Karşılama / kayıt / giriş | E-posta, Apple ve Google yöntemleri; açık gizlilik/koşul erişimi | Yeni/mevcut hesap, provider iptali, ağ sorunu, genel giriş hatası |
| E-posta doğrulama | Kod/link, tekrar gönder, adres düzelt | Süre doldu, tekrar kullanılmış, yanlış kod, oran sınırı |
| Şifremi unuttum / yeni şifre | Kurtarma talebi ve yeni şifre belirleme | Hesap varlığı gizli, tek kullanımlık işlem, eski oturum iptali |
| Hesap tamamlama / rol | Sporcu, antrenör veya ikisi; kaldığı yerden devam | Koşullar, hedef kitle uygunluğu, davetle dönüş, kısmi onboarding |
| Başlangıç ve profil | Hedef/geçmiş/koşul belirleme | Atla, eksik veri, hassas alan açıklaması |
| Giriş yöntemleri | Bağlı e-posta/Apple/Google, ekleme/kaldırma | Step-up, kimlik çakışması, relay e-posta, son yöntem koruması |
| Oturumlar ve güvenlik | Bu/diğer iPhone oturumları; kullanıcı personelse admin web oturumları, varsa P1 antrenör web; logout/revoke-all | Başka oturum iptali, MFA/step-up, hesap değiştirmede cache temizliği |
| Hedefler | Çoklu hedef ve öncelik | Çatışma, değişiklik etkisi |
| Zaman ve ekipman | Haftalık düzen/istisna | Sabit gün, seyahat, kısıt |
| Veri aldığım uygulamalar | Kaynak uygulama, Apple Health köprüsü veya hesap API’si | Aktarım yönü, kategori kapsamı, son olay/son sync ayrımı, doğrulanmamış iOS kaynağı |
| Veri izin kurulumu | Kategori/amaç/geçmiş aralığı, backend aktarımı ve gerçek OS talebi | Atla, kısmi, bilinmeyen izin, köprü paylaşımı eksik, ilk veri bekleniyor |
| İzin merkezi | Kaynak okuma, platform işleme, AI, koç ve bildirim | Kapsam daraltma, izin geri çekme, yeniden bağlanma ve etki açıklaması |
| İlk plan oluşturma | Girdi özeti, taslak ve onay | Üretim, yetersiz bilgi, geçersiz/uygunsuz taslak |
| Bugün | Tek ana öneri, gerekçe ve eylem | Güncel/eski veri, onay bekleme, dinlenme veya öneri verememe |
| Haftalık plan | Seanslar ve haftanın amacı | Geçmiş/aktif/taslak ayrımı, taşıma ve kilit |
| Plan değişikliği | Önce/sonra ve sonraki günlere etki | Kabul, ret, stale öneri |
| Seans rehberi | Isınma/çalışma/dinlenme/soğuma ve hedef yoğunluk | Çevrimdışı reçete, dış uygulama kaydını bekleme; başlat/duraklat/kaydet yok |
| Günlük/sonrası kontrol | Kısa geri bildirim | Daha önce verilen yanıtı tekrar sormama |
| Geçmiş ve ilerleme | İçe alınan gerçek kayıt, beyan, plan/gerçekleşen farkı | Uygulama + erişim yolu, eksik dönem, tahmin ve eşleştirme etiketi |
| Koç sohbeti | Doğal dilde soru ve değişiklik talebi | İşlem önizlemesi, onay, hatayı geri alma |
| Antrenör ve paylaşım | Davet, kapsam, erişim iptali | Transfer ve özel not ayrımı |
| AI ayarları | Platform modeli/BYOK/custom endpoint | Test, desteklenmeyen görev, izin, bütçe, anahtar silme |
| Gizlilik ve hesap | Veri kullanım görünümü, export ve silme | İş durumu ve dış alıcı sınırlarının açıklaması |
| Hesabı sil | Silme etkisi, yeniden doğrulama ve açık onay | Bekliyor/tamamlandı/tekrar gerekli; dış kaynağı silmeme; çıkış ile fark |
| Üyeliğim ve erişim | Ücretsiz/ücretli/bedelsiz paket, süre, kullanım hakkı ve doğru kaynak | Yenileme kapalı ama erişim sürüyor; grace/expired; geçmiş/izin/silmeye erişim |
| Satın alma / geri yükle / yönet | Yalnız onaylı satış kanalında gerçek ürün/fiyat/koşul ve resmî akış | Bekliyor, iptal, doğrulama bekleniyor, sahiplik çakışması, ağ/app kapanması; ücretsiz modda sahte paywall yok |
| Yardım ve destek kayıtlarım | Kısa konu/mesaj, mevcut talepler ve kullanıcıya açık yanıt | Hassas sağlık bilgisi paylaşmama uyarısı; iç not görünmez; üyelik bitse de destek açık |

Ana ekran sohbet kutusu değildir. Kullanıcıya önce bugün ne yapılacağı ve neden önerildiği gösterilir; sohbet bu deneyimi destekler. Görsel stil ürün ekibine bırakılır; erişilebilirlik, dinamik yazı boyutu, birim/dil tutarlılığı ve okunabilir durumlar zorunludur.

**Çok sporlu ekran gereksinimleri:** Onboarding'de spor/aktivite seçimi ve branş bazlı deneyim; katalogda kategori ağacı ve çoklu filtre; hareket/drill/poz ayrıntısında gerekli ekipman, kullanım bağlamı, onaylı talimat, alternatif ve içerik sürümü; haftalık editörde branşa özgü alanlar bulunur. Sırt → çekiş → ekipman gibi kullanıcı gezinmesi yanında Pilates → mat/reformer → pozisyon/seri veya yüzme → stil/drill gibi akışlar eşit düzeyde desteklenir. Branş yetenek/güncellik/eksik veri durumu görünürdür; yüzlerce isim göstermek çalışan koçluk sayılmaz.

Katalog salt okunur gezilebilir. Kullanıcı açık rol/yetki akışıyla özel öneri oluşturabilir; global listeyi değiştiremez. Spor tercihi Apple/Google login veya sağlık izinlerini yeniden ya da daha geniş almak için gerekçe değildir.

### 15.2 P0 native iPhone antrenör çalışma alanı; P1 web karşılığı

E-posta/Apple/Google kayıt-giriş, e-posta doğrulama ve kurtarma; sporcu listesi; sporcu detay/geçmiş; haftalık plan editörü; yaklaşan seans brifingi; onay kuyruğu; notlar; davet ve erişimler; giriş yöntemleri, oturumlar, MFA/step-up ve hesap silme. Bu ekranların P0 karşılığı native iPhone uygulamasındadır; rol geçişi hesap değiştirmek değildir. Organizasyon/kurum AI yönetimi ve ayrı masaüstü web istemcisi P1’dir. P1 web eklendiğinde aynı User/AuthIdentity altyapısını kullanır; tarayıcı HealthKit izni isteyemez. Kendi sporcu hesabını bağlamayan antrenörden sağlık izni isteme.

Antrenör panelinde çok sayıda grafik yerine önce karar gerektiren değişiklikler görünür. Ekrana yansıtılan alarm/öncelik tıbbi tanı etiketi taşımaz.

**Antrenör katalog iş akışı:** Branş/uzmanlık filtreli sporcu listesi; kas/ekipman/drill aramalı plan editörü; özel içerik/şablon taslağı; branş şeması doğrulama; sabit ders/maç ve içerik sürüm farkı görünümü bulunur. İç operasyon için kaynak import/coverage, eşleme, çeviri, hak ve uzman inceleme kuyrukları P0 özel web admin panelinde, yetkili yönetim API’leri üzerinden sunulur. İnceleme/onay/audit ve içerik yetkileri korunur; bu panel antrenör web’inin P1 durumundan bağımsızdır. Bu ekranların varlığı koça diğer sporcuların verisine veya platform gizli anahtarlarına erişim vermez.

**Telefon-öncelikli antrenör UX’i:** Müşteriler → sporcu brifingi → haftalık plan → gün/seans/blok editörü → fark/onay akışı tek telefonda tamamlanabilir. Yedi sütunlu masaüstü tabloyu küçültüp sığdırmak yerine gün seçimi ve dikey blok kartları kullanılır. Sürükle-bırak tek düzenleme yolu olmaz; taşı/çoğalt/düzenle düğmeleri ve erişilebilir alternatif gerekir. Mini ekranda klavye açıkken onay/iptal kaybolmaz. Hesap/rol değişiminde önceki sporcunun verisi kısa süre bile yeni sporcu başlığı altında gösterilmez.

**Genel iOS UX:** İlk açılış, Face ID/Touch ID veya hesap doğrulama iptali, cihaz kilidi, sistem yazı boyutu, koyu/açık görünüm, Türkçe uzun metin ve VoiceOver test edilir. Biyometrik kimlik doğrulama kullanılırsa yalnızca OS hesabı/anahtar koruma mekanizmasıdır; Sportapp yüz/parmak izi ölçmez veya şablon toplamaz. Destek/uyumluluk ekranı uygulama build/OS, veri son güncelliği, bağlantı kısıtı ve güvenli yardım bilgisini gösterir; yeni OS özellikleri eski OS’de ana akışı kaldırmaz.

### 15.3 Zorunlu ifade ve etiket ayrımları

“Ölçtük” yerine “Apple Health üzerinden aktarıldı”; “Nabzın şu anda…” yerine “Son aktarılan antrenmandaki nabız…”; “Kayıt başlat” yerine “Seans ayrıntısını gör”; “Saat bağla” yerine “Veri aldığım uygulamalar”. Kullanıcı beyanları ve Sportapp tahminleri aynı listede olabilse de etiketleri farklıdır.

Boş veride ilk çözüm başka cihaz bağlatmak değildir. Kaynak uygulamada kayıt var mı, Apple Health’e ilgili tür yazılmış mı, Sportapp’a okuma izni verilmiş mi, kayıt zaman aralığı kapsanıyor mu soruları sırayla ele alınır. Kullanıcıdan ek bilgi yalnızca eksikliği gidermek gerektiğinde istenir.

**Login/izin metni ayrımı:** “Apple ile devam et” hesap girişidir; “Apple Health verilerini bağla” veri erişimidir. “Google ile giriş yaptın” yerine sağlık bağlantısı ekranında ayrı gerçek kapsam gösterilir. Bir izin kutusunu açmak OS penceresinin yerini almaz. “Tüm izinler tamam” yerine hangi veri kategorilerinin gerçekten görüldüğü belirtilir. “Şimdilik atla” seçeneği cezalandırıcı veya yanıltıcı bir metinle sunulmaz.

### 15.4 P0 web admin ekranları ve basit gezinme

**Sol menü:** Genel Bakış · Kullanıcılar · Üyelikler ve Ücretler · CRM ve Destek · Katalog/Operasyon · Ayarlar ve Yetkiler. Alt ekranlar aynı menü grubu altında açılır; ilk sürümde onlarca ayrı modülle gezinme şişirilmez. Arama/filtre/sayfalama ve kayıt ayrıntısı ortak bileşenlerdir.

| Ekran | Ana işlev | Zorunlu durum / sınır |
|---|---|---|
| Admin giriş / MFA / kurtarma | Davetli personelin güvenli oturumu | Davet süresi, rol iptali, MFA yok, recovery; genel üye kaydıyla erişim yok |
| Genel Bakış | Kayıt/üyelik/para birimi bazlı tahsilat ve görev/destek özeti | Tanım, filtre, güncellik, veri yok ve henüz doğrulanmadı; sahte örnek KPI yok |
| Kullanıcılar | Kayıt/doğrulama/rol/hesap/üyelik filtreleri; arama | Sunucuda sayfalama; minimum kişisel alan; ham sağlık yok |
| Kullanıcı kartı | Hesap, üyelik, ödeme özeti, CRM zaman çizelgesi ve aksiyon | Destek/finans alan izinleri; hesap askısı/silme/üyelik ayrı |
| Üyelikler ve paketler | Paket/fiyat sürümü; etkin/bitecek/ücretsiz/ücretli erişim | Draft/mağaza hazır değil; telafi ≠ ödeme; fiyat değişimi etkisi |
| Ödemeler ve mutabakat | İşlem/iade/durum, kanal, belgeler ve eşleşmeyen kayıt | Sandbox/prod ayrımı; provider yeteneği yok; bekleyen doğrulama |
| CRM görevleri | Benim/tüm yetkili görevler, gecikenler, atama, bitirme | Sorumlu silindi/izin değişti; reminder dedupe; basit durumlar |
| Destek kayıtları | Kategori, sorumlu, durum, kullanıcı yanıtı ve ayrı iç not | Gizli notu kullanıcıya yollamama; sağlık verisi iznini devralmama |
| Katalog ve operasyon | Mevcut import/review/publish, bağlantı/görev hata özetleri | Sadece ilgili izin; güvenli retry, maskeli hata, kayıt/sensör yok |
| AI/kota ve ürün ayarları | Platform kullanımı, limit policy, varsayılan bağlantı referansı | BYOK secret yok; alıcı değişimi eski izni genişletemez |
| Personel / roller / audit | Davet, role/scope ataması, oturum iptali ve denetim | MFA, son OWNER, step-up; değişmez mali kayıt, hassas export kontrolü |

Dashboard tasarım olarak karar noktalarını öne alır; grafikleri doldurmak için sağlık verisi veya yapay satış üretmez. Destek yetkilisi üyenin kişisel sağlık ekranına “kullanıcı gibi giriş yap” yapamaz. Tablo verileri role göre backend’de daraltılır; CSS ile saklamak kabul edilmez.

P0 web desteği D0’da pinlenen masaüstü Safari/Chrome/Edge/Firefox kararlı sürümlerinin mevcut ve bir önceki ana sürümü için test matrisi olarak tanımlanır; eski/iOS tarayıcı desteği ilan edilecekse ayrıca testlenir. Responsive tablet görünümü yararlıdır; kullanıcıların iPhone 12 işletim sistemi desteği web tarayıcı sürüm politikasına bağlanmaz. Modern tarayıcı güncellemesi native minimum iOS’u yükseltmez. Klavye, ekran okuyucu, odak/hata durumu ve büyük yazı zorunlu UX kabulüdür.

## 16. Gizlilik, ürün güvenliği ve yayın koşulları

Sportapp’ın ölçüm yapmaması, kişisel sağlık verisi işlemediği anlamına gelmez. İçe alınan verinin sunucuya/AI’a aktarımı da izin ve gizlilik gerektirir. Apple, üçüncü taraf AI dahil kişisel verinin nereye paylaşılacağına dair açık bilgilendirme ve izin ister. Sağlık verisi kullanımında ek sınırlamalar vardır. AI sağlayıcısı ve sağlık verisi aktarım akışı, yalnızca genel kullanım koşullarına gömülmez; kullanıcının işlem bağlamında gördüğü açıklamaya dönüştürülür. [S1]

İzin kapsamları birbirinden ayrılır: dış sağlık uygulaması/veri deposundan okuma, platformda işleme, seçilen AI sağlayıcısına gönderme, belirli antrenöre gösterme, arka plan AI işleri, dosya dışa aktarma. İzin süresi, alıcı ve amacı sürümlüdür. Yeni endpoint veya yeni alıcı, eski iznin otomatik kapsamı sayılmaz.

Her kuyruk işi çalışmaya başladığında ve dışarı veri çıkarmadan önce izin tekrar doğrulanır. İzin iptali henüz gönderilmemiş istekleri durdurur; daha önce üçüncü tarafa gönderilmiş verinin geri alınması sağlayıcının gerçek imkanları ve sözleşmeleriyle sınırlıdır.

Veri saklama süreleri, silme ve backup temizleme akışı, erişim kayıtları, export ve türetilmiş veri/cache temizliği belirlenir. Tarihsel karar izi sonsuza kadar ham kişisel veri saklamak için gerekçe değildir; audit ile silme hakları birlikte tasarlanır.

Sağlık verileri reklam hedefleme veya model eğitimi için varsayılan bir kaynak yapılmaz. Ticari modüller antrenman karar motorundan ayrılır. Sporcu aboneliği zorunlu bir mimari bağımlılık değildir. **v6’da üyelik/fiyat/ücret takibi ve web yönetimi P0’dır;** gerçek satış modeli ve ödeme kanalını açma BILLING-001 koşullarına bağlıdır. Her üyeye otomatik ücret veya kampanya dayatılmaz; ileri kurum satış/finansman süreçleri ayrı kapsamdır.

KVKK/GDPR ve hedef pazara uygun işleme/aktarım şartları, App Store sağlık/AI açıklamaları, sağlayıcı sözleşmeleri ve sağlık ürünü iddiaları için uzman hukuki değerlendirme yayın kontrolünün parçasıdır. Bu belge tek başına hukuki uygunluk veya klinik doğrulama belgesi değildir.

Salt okunur erişim “veri toplanmıyor” iddiasına gerekçe olamaz. App Store gizlilik beyanında uygulama dışına aktarılan/saklanan sağlık ve fitness verileri ile üçüncü taraf işleme doğru açıklanmalıdır. [S8]

Kaynak hesabını bağlamak için kullanıcının Apple/Google/Huawei/Samsung şifresi istenmez. Resmî OS izni veya hesap yetkilendirme akışı kullanılır; özel uygulama dosyaları, ekran kazıma veya tersine mühendislikle veri erişimi yapılmaz. OAuth iptali/bağlantı kesme ile platform hesabı silme ayrı eylemlerdir.

**Kayıt/izin yayın kapısı (v6):** E-posta, Apple ve Google girişlerinin gerçek iPhone doğrulaması (P0 admin web için ayrıca MFA/RBAC/CRM/finans testleri; P1 antrenör web açıldığında onun testleri), relay e-posta, güvenli kurtarma, sağlayıcı token iptali, izin ret/kısmi/geri çekme, aynı telefonda hesap değiştirme ve uygulama içi silme akışları test edilmeden P0 tamamlanmaz. App Store incelemesi için gerçek kullanıcı sağlık verisi içermeyen demo erişim/örnek veri hazırlanır; review erişimi bir üretim auth bypass’ı değildir. Apple’ın login, gizlilik ve hesap silme kuralları yayın anında yeniden kontrol edilir. [S1][S27]

Kayıt koşulları, gizlilik aydınlatması, sağlık verisi işleme dayanağı, AI alıcısı ve pazarlama rızası tek “her şeyi kabul et” kutusuna dönüştürülmez. Bir üçüncü taraf SDK’sının kendi izin ekranı Sportapp’ın backend/AI işleme açıklamasının yerine otomatik geçmez. İzin vermeme/kaldırma akışı, izin verme kadar bulunabilir olmalıdır.

**iOS yayın kapısı:** Bölüm 1.6’daki destek açığı/kararı, arşiv-minimum OS eşleşmesi ve bütün P0 native rollerin cihaz/OS testleri ayrıca gerekir. “iPhone 12 ve sonrası” ifadesi test planında yalnızca en son Pro modelin bulunmasıyla karşılanmış sayılmaz. Destekli eski OS’yi dışlayan paket değişikliği, mağaza arşivi veya görünmeyen onay ekranı sürüm engelidir.

**Admin/finans yayın kapısı:** Yeni web yüzeyi tehdit modeline eklenir; personel daveti/MFA/kurtarma, session/CSRF/XSS/IDOR, alan scope’u, CSV export, kullanıcıya açık destek yanıtı ve kurum izolasyonu testlenir. Fiyat/üyelik değişimi, gerçek para olayı, geçmiş kullanıcı migration ve iOS ücretsiz/ücretli görünümü tutarlıdır. Satış açılacaksa seçilen kanalın imza doğrulama, test satın alma/geri yükleme/iptal/iade/duplicate/out-of-order/sahiplik testleri kanıtlanır; ödeme sağlayıcısı şartı App Store onayı yerine geçmez. Fiziksel cihaz ve mağaza koşulları sürüm bazında kontrol edilir.

Admin role sahip olmak KVKK/GDPR işleme ve kaynak lisans sınırlarını kaldırmaz. Destek kayıtları, fiyat ve mali belge saklama kapsamı ayrıca dokümante edilir. Admin kullanıcının sağlık/AI/antrenör rızasını onun adına işaretleyemez. Abonelik/hak değişimi, hesap silme ve aktif sağlayıcı aboneliği ayrı yaşam döngüleridir; bu ayrım kullanıcıya açıkça anlatılır.

## 17. Geliştirme planı — iPhone, web admin, CRM/ücret, katalog, kimlik ve uygulama verisi

Aşamalar teslim süresi tahmini değildir; her aşama giriş bağımlılıkları ve doğrulanabilir çıkış koşuluyla yönetilir. Spor kataloğu, içerik incelemesi ve gerçek kaynak erişimi ayrı iş akışlarıdır. Katalog işi bitmiş diye veri entegrasyonu veya teknik koçluk bitmiş sayılmaz.

| Aşama | Bağımlılık | Yapılacak işler | Teslimat | Geçiş / kabul koşulu |
|---|---|---|---|---|
| D0 — Mevcut durum ve kapsam | Mevcut repo/bilinen ortam | As-is analizi; auth/izin/kaynak matrisi; dar spor enum'larının tespiti; Garmin kaynak sürümü/hak/kapsam; branş yetenek matrisi. iPhone model/OS kapsamı, IOS-SUPPORT-001, native coach migration, araç/SDK/runtime/bağımlılık farkı. Admin web kapsamı, mevcut RBAC/üye kayıtları, BILLING-001 ve kanal/satış türü, minimum CRM veri sınırı. | Fark analizi, ADR'ler, katalog ve izin backlog'u, geçiş planı; IOS_SUPPORT_MATRIX, IOS_DEPENDENCIES taslağı ve açık karar kaydı. ADMIN_RBAC_MATRIX, BILLING_CHANNEL_MATRIX, ADMIN_SCREEN_CONTRACTS ve CRM_RETENTION taslağı. | Koşu/kuvvet/HYROX tek hedef kitle değil; HIIT/fonksiyonel/Pilates P0 teslimi açık; dış engeller ayrı kayıtlı. iOS 14 açığı görünür; destek tabanı izinsiz daraltılmaz; antrenör web’i P0 bağımlılığı değil; özel admin web’i P0. Admin web P0, antrenör web P1; fiyat/tahsilat yolu uydurulmaz. |
| D1 — Kimlik, izin ve AI temeli | D0 | E-posta/Apple/Google; oturum/link/recovery; ayrı izin kararları; kasalı anahtar saklama; platform LLM/BYOK gateway. Native iOS shell, scene/rol yönlendirmesi, alt OS uyumlu depolar ve güvenli callback. Web admin shell, davetli personel+MFA/oturum ve DB izinleri; kullanıcı kartı salt okunur ilk dilim. | Çalışan hesap ve AI bağlantı akışları Sabitlenmiş iOS toolchain/lockfile ve ilk CI build. Gerçek tarayıcı oturumu ve staff/User scope ayrımı. | Gerçek sağlayıcı doğrulaması; login≠health≠AI≠coach; model seçiminde sessiz fallback yok. En düşük aday OS’de auth bağımlılıkları derlenebilir; beta build üretim kanıtı değil. Genel üye admin’e giremez; MFA ve oturum iptali çalışır. |
| D2 — Profil ve uygulama geçmişi | D1, D0 kaynak matrisi | Branşa özgü profil/hedef/uygunluk; HealthKit salt okunur ve beyan; app provenance; kaynak etiketi/granularity; tekrar ve silme davranışı. Sürüme göre HealthKit türleri; kilit/arka plan/force-quit; büyük ilk aktarım ve cursor. Kayıt event’inden tekil CRM kartı, güvenli kullanıcı listesi, ücretsiz/var olan üyelik backfill. | Kullanılabilir sporcu geçmişi, veri kapsamı raporu Cihaz/OS/kaynak sürümlü read-only veri raporu. Kullanıcı idari özeti ve kayıpsız v5 migration. | Kayıt özeti hareket ayrıntısı sanılmaz; bilinmeyen branş kaybolmaz; gerçek iPhone/uygulama izin kanıtı. Kaynak uygulama min OS’si Sportapp desteğiyle karıştırılmaz; eski OS’de olmayan veri uydurulmaz. İçe alınan sağlık verisi CRM’ye kopyalanmaz; eski üyeye borç/tahsilat üretilmez. |
| D3 — Katalog ve spor paketleri | D0; D1 yetkileri | Pinlenmiş FIT sözlüğünün tam staging import'u; menü alias'ları; kanonik hiyerarşi; kas/örüntü/ekipman; tipli bloklar; içerik review ve policy. Telefon için sayfalı/indeksli katalog; eski istemciye uyumlu tipli seans temsili. Mevcut katalog review/import/yayın için web admin ekranları; ticari paket/fiyat/grant ve para olay şemaları. | Sürümlü seed/manifest/diff, katalog API'si, disiplin şemaları, uzman inceleme kuyruğu Native arama sözleşmesi ve catalog schema version. DB tabanlı paket/hak/mali model, taslak fiyat kataloğu. | Tam kaynak kapsamı ayrı sayımla; onaylı içerik ve tipli doğrulayıcılar; v3 planlarında veri kaybı yok; cihaz SDK bağımlılığı yok. Tam katalog RAM’e yüklenmez; Garmin SDK iPhone’a gömülmez. Kaynak içeriği ve ticari fiyat geçmişi ayrı; panelden mağaza fiyatı değişmiş sayılmaz. |
| D4 — Çok sporlu haftalık plan | D1–D3 | Yarış dışı hedefler dahil strateji, farklı branşlarda hafta taslağı, süre/kısıt kontrolü, önizleme/onay ve manuel editör. Mini ekrana uygun gün/blok editörü ve native fark/onay; eski OS alternatifi. Üyelik ekranı ve sunucuda kota/hak kontrolü; ücretsiz+BYOK/platform seçenekleri korunur. | Platform/BYOK ile gerçek haftalık plan; gerçek iPhone’dan tamamlanan hafta oluşturma/onay. Planlama ile ticari hak sınırını ayıran testli akış. | Pilates+kuvvet+yüzme ve HIIT+başka branş akışları; yalnızca başlığı değiştirilmiş koşu şeması değil; uygun değilse INFEASIBLE. Ana akış yeni OS frameworküne veya web paneline bağımlı değil. Ücret/rol/sağlık izni karışmaz; paywall rızayı zorlamaz. |
| D5 — Rehber, gerçek kayıt ve geri bildirim | D2–D4 | Branşa uygun seans ayrıntısı; çevrimdışı snapshot; dış kaydı ilişkilendirme, kısmi/eksik beyan. Korumalı local cache/outbox, uygulama güncellemesi/OS geçişi ve performans profili. CRM not/etiket/görev/destek web akışı ve iPhone yardım formu; sahip/süre ve iç not/açık yanıt. | Plan → dış kayıt/beyan → sonuç döngüsü iPhone 12/mini üzerinde offline ve migration kanıtı. Kullanıcı → destek → personel → yanıt/takip döngüsü. | Başlat/duraklat/ölçüm yok; planlanan setler gerçekleşmiş kabul edilmez; eksik veri etiketi doğru. Cache başka hesaba geçmez; uygulama kapanınca seans/plan kaybolmaz. Sağlık/koç notu ve admin iç notu kullanıcı desteğine sızmaz. |
| D6 — Branşlar arası adaptasyon | D4–D5 | Plansız aktivite/sabit ders/maç; farklı yük boyutları; ekipman/amaç uyumlu alternatifler; hafta değerlendirmesi. Backend AI job devamı, client schema yeteneği ve bildirimin eski/yeni OS davranışı. Seçili satış kanalı adaptörü, iPhone satın alma/restore, doğrulama/webhook/inbox/mutabakat; membership-grant lifecycle. | Günlük ve sonraki hafta değişiklikleri Kapanıp açılan iPhone’da tutarlı plan adaptasyonu. Ücretli mod seçildiyse gerçek sandbox uçtan uca kanıt; ücretsiz modda kapalı satış durumu. | Hareket/kas verisi yoksa belirsizlik; tüm sporlara tek nabız/koşu km hesabı yok; kilit/onay/izin korunur. Apple Intelligence şartı yok; işleme anında izin/sürüm yeniden kontrol edilir. Pending/failed/free gelir sayılmaz; yinelenen/geç event ve hesap değişimi güvenli; yeni ücretli işlemler ancak doğrulanmış kanalda. |
| D7 — Antrenör ve içerik iş akışı | D1, D3–D6 | Antrenör onboarding; branş uzmanlığı; katalog aramalı editör; özel drill/şablon; brifing, onay, erişim ve devir. Bütün COACH P0 akışlarını aynı iPhone uygulamasında teslim et; tarayıcı panelini P1 ayır. Üye ayrıntısı, ödeme/üyelik filtreleri, operasyon dashboard’u, finance/support ayrımı ve güvenli idari işlemler. | Çalışan çok branşlı antrenör paneli; native sporcu/antrenör rol geçişi ve çalışma alanı. Gerçek kayıtlara bağlı çalışan admin paneli. | Özel içerik izolasyonu; sporcunun geçmiş reçetesi ile koçun tam kütüphanesi ayrılır; eski erişim/cache kapanır. iPhone’dan müşteriye plan hazırlanır/onaylanır; koçun HealthKit verisi müşteriye yüklenmez. Native koç geçmişi/izinleri aynı kalır; ürün sahibi admin panelinden koç izni kazanmaz. |
| D8 — Yaşam döngüsü ve ürün tamamlama | D5–D7 | İzin/AI/hesap ayarları; katalog arama/yerelleştirme; bildirim/kota; export/delete/revoke; içerik geri çekimi. APNs hesabı, deep link, Dynamic Type/VoiceOver, privacy manifest ve update/support UX. Finans belge/ref ve sınırlı CSV, CRM/finans retention, rol iptalinde cache/job, provider/destek bildirimleri. | Uçtan uca yönetilebilir P0 iOS release checklist ve son cihaz-OS matrisi. Web admin işletim ve billing runbook’u, mali silme/hesap silme ayrımı. | Son login yöntemi korunur; hesap silme gerçek; kaynak verisi değişmez; geçmiş içerik sürümleri izlenebilir. OS kısıtları yanlış izin/başarılı eşitleme gibi sunulmaz. Üyelik sonu geçmiş/izin/silme yolunu kapatmaz; silinen üye geç event’le dönmez. |
| D9 — Doğrulama ve kontrollü yayın | D1–D8 | Auth/izin/gerçek app verisi; katalog kapsamı; tipli seanslar; her P0 spor paketi; platform/BYOK; uzman/antrenör gözetimli pilot. iPhone 12 ailesi ve sonraki form faktörleri; onaylı OS kolları; gerçek dağıtım arşivi. Admin tarayıcı güvenlik/akış testleri, yeni kullanıcı/CRM/hak/ödeme regresyonları ve seçili kanal sandbox kanıtı. | Test/coverage raporu, privacy checklist, rollback Native E2E/perf/uyumluluk kanıtı ve App Store aday arşivi. Admin/CRM/ücret kabul raporu; NOT_RUN/NOT_APPLICABLE açık ve gerekçeli. | 220 senaryonun ilgili P0 koşulları kanıtlı; P1 ayrı; HIIT/fonksiyonel/Pilates gerçek akışı yoksa P0 tamam denmez. 220 senaryonun uygulanabilir P0 kapsamı ve açık platform/ticari kararları denetlenir; test edilmemiş sürüm geçti sayılmaz. 220 senaryonun uygulanabilir P0 koşulları; satış açılan kanalda ödeme testini ücretsiz mod gerekçesiyle atlama yok. |
| D10 — Onaylı genişleme | D9 ve ilgili onaylar | Ek uygulama API'leri, Samsung doğrulanmış yol, dosya import/takvim/kurum/passkey; yeni kaynak sürümleri ve branş uzmanlık paketleri. Ayrı antrenör web/Android ancak açık kapsam kararıyla; yeni iPhone/iOS ve kaynak sürümü kontrolleri. İhtiyaç halinde ikinci ödeme sağlayıcısı, e-fatura/muhasebe, tam CRM entegrasyonu; ayrı iş kararı. | Bağlantı/branş bazlı doğrulanmış yetenek artışı; onaylanmış yeni platform veya sürüm genişletmesi. Genişleme öncesi veri/izin/kanal etki analizi. | Geniş katalog P1'e ertelenmez; ileri koçluk içeriği ayrı kanıtlanır; medya haklı; ölçüm/sensör/cihaz işi eklenmez. Web/Android başlatmak P0 iOS tamamının yerine geçmez; sensör/cihaz yasağı korunur. P0 admin/üyelik/minimum CRM sonraya ertelenmez; kampanya ve payout kendiliğinden eklenmez. |

### 17.1 D0 teslimatları ve doğrulama kapıları

**Yeni platform teslimleri:** `IOS_SUPPORT_MATRIX.md`, `IOS_DEPENDENCIES.md`, `IOS_TEST_PLAN.md`, `IOS_RELEASE_CHECKLIST.md`, `ADR-IOS-SUPPORT-001.md` ve rol bazlı iPhone ekran/akış eşlemesi. Her dosyada istenen, önerilen, doğrulanmış ve açık kalan durum ayrı yazılır. Minimum OS sayısını tüm projeye yaymadan tek karar/kaynak üzerinden yönetin; bütün target/paket/CI/mağaza metadata kontrolleri buna bağlansın.

Mevcut bileşenler, korunacak/değişecek parçalar, veri akışı, kaynak matrisi, sağlayıcı hakları, teknik kararlar, bağımlılık sıralı issue listesi ve ilk uçtan uca dilim hazırlanır.

**v6 D0 teslimatları:** `ADMIN_RBAC_MATRIX.md`, `ADMIN_SCREEN_CONTRACTS.md`, `MEMBERSHIP_ENTITLEMENTS.md`, `BILLING_CHANNEL_MATRIX.md`, `BILLING_STATE_MAPPING.md`, `BILLING_RUNBOOK.md`, `CRM_DATA_RETENTION.md`, `METRICS_DEFINITIONS.md` ve `V5_TO_V6_MIGRATION.md`. Aynı doküman altında bölümler olabilir; gereksiz dosya zorunluluğu yoktur. Yalnızca ekran çizimi değil role/permission → API → veri alanı → kabul testi eşlemesi gerekir.

`BILLING-001` kararı `FREE / PAID / MIXED`, ürün türü, tutar/para birimi, satıcı, mağaza, kanal, provider hesabı, doğrulama/anahtar referansı, App Store ürün eşlemesi ve hukuki sorumluluğu içerir. Kodlama LLM’i ürün sahibine ait olmayan API anahtarı, canlı fiyat, banka bilgisi veya onay üretmez. Gerçek tahsilat ve mağaza testleri dış hesap yoksa `BLOCKED_EXTERNAL`; ücretsiz kullanıcı/admin/CRM ve yerel contract testleri sürer.

Auth matrisi ortam/platform/client/issuer/audience/redirect/secret referansı/test kanıtı; izin matrisi amaç/kategori/kaynak/alıcı/hukuki değerlendirme/metin sürümü/iptal etkisi içerir. `PERMISSION_FLOWS.md`, `AUTH_THREAT_MODEL.md` ve `ACCOUNT_LIFECYCLE.md` D0/D1’de oluşturulup D2/D8’de uygulama kanıtıyla güncellenir.

Her kaynak matrisi satırı: `source_app`, `platform`, `account_region`, `access_route`, `read_direction`, `data_types`, `history_window_observed`, `permissions`, `revisions_deletions`, `ai_coach_use_conditions`, `documentation_checked_at`, `test_evidence`, `implementation_status`, `blocking_dependency`.

Her iş: `task_id`, `feature_ids`, amaç, kapsam dışı, bağımlılık, modül/veri değişikliği, kabul kriteri, test, dış bağımlılık ve tamamlanma kanıtı.

Resmî API erişimi, geliştirici onayı, test hesabı, iPhone veya imza sertifikası eksikse ilgili iş `BLOCKED_EXTERNAL` olur. Giyilebilir cihaz şartı koyma; burada doğrulanacak şey sağlık uygulamasındaki mevcut kaydın okunmasıdır. Mock/örnek veri başarısı gerçek entegrasyon kanıtı sayılmaz; engellenmemiş işleri sürdür.

D2’de en az Apple Health okuması ve Google/Huawei köprü yollarının gerçek uygulama denemeleri raporlanır. Her kategorinin başarı/eksik/henüz test edilmedi sonucu ayrı yazılır. Genel “Huawei tamamlandı” yerine örneğin “egzersiz süresi doğrulandı, evreli uyku aktarımı doğrulanmadı” biçimi kullanılır.

**Katalog için D0 kanıtı:** FIT sürümü/hash ve lisans incelemesi; kontrol edilen resmî model kılavuzları; sözlük ile menü alias farkı; Sportapp ek içerik listesi; disiplin/paket bazlı yetenek, uzman incelemesi, ayrıntılı veri aktarımı ve eksik metadata matrisi hazırlanır. `CATALOG_COVERAGE.md`, `SPORT_CAPABILITIES.md`, `CONTENT_REVIEW_POLICY.md`, `CATALOG_MIGRATION.md` ve `SOURCE_LICENSES.md` sürümlenir. Kaynak türü sayısı veya hareket adı adedi, incelenmiş reçete adedi olarak raporlanmaz.

### 17.2 İlk uçtan uca dilim

**v5 cihaz kapısı:** Aşağıdaki akışın ilk teknik dilimi iPhone 12 veya 12 mini ve en düşük onaylanmış/teste uygun OS kolunda; ayrıca güncel kararlı OS’de çalıştırılır. Antrenör kısmı ayrı web tarayıcısından değil native iPhone rolünden tamamlanır. D0 iOS 14 açık kararı çözülmeden bu dilim “tarihsel bütün sürümler tamam” kanıtı değildir.

E-posta/Apple/Google ile hesap aç veya mevcut hesaba gir → koşulları/rolü tamamla → örneğin Pilates+kuvvet+yüzme için branş deneyimi/hedef/uygunluk gir → sağlık bağlantısını atla veya kategori bazlı platform işleme + HealthKit izni ver → ilk izinli veriyi getir → platform LLM/BYOK alıcısını seç ve onayla → haftalık planı doğrula/yayımla → dış uygulama kaydı veya kısa beyanı ilişkilendir → kalan hafta değişikliğini öner/onayla → bir paylaşım iznini geri çek ve yeni işlemin gerçekten durduğunu göster.

Aynı akışın tekrar giriş, Google/Apple yöntemi bağlama ve logout sonrası başka hesapla açılış varyantı da test edilir. İlk teknik prototipte sentetik veri kullanılabilir; gerçek auth ve iPhone veri/izin testleri ayrıca raporlanır. Giriş düğmesinin görünmesi veya OS izin penceresinin kapanması tek başına uçtan uca başarı değildir.

Ayrıca HIIT + fonksiyonel ve sabit tenis dersi kombinasyonunda aynı döngüyü çalıştır. Yalnızca koşu/kuvvet/HYROX demolarının geçmesi çok sporlu P0 kanıtı değildir. Bir Pilates-tek-branş kullanıcısında yarış/HR hedefi olmadan plan üretimi; başka kullanıcıda koşu + yüzme + kuvvet birlikte test edilir. Bu örneklerde kaynaktan sadece seans özeti geliyorsa hareket detayları uydurulmaz.

**v6 web admin uçtan uca dilimi:** Yeni kullanıcı iPhone’dan kaydolur → admin kullanıcı listesinde tekil kayıt görünür → ücretsiz üyelik durumu ve onboarding özeti görülür → destek notu/etiket ve son tarihli görev eklenir → iPhone’dan destek talebi açılır → panelden kullanıcıya açık yanıt verilir → süreli bedelsiz telafi hakkı yetkili/gerekçeli verilir → iPhone hak görünümü güncellenir → aynı akışta kullanıcı sağlık/AI izinleri değişmez. Destek yetkisinin kaldırılmasından sonra eski tarayıcı/iş kuyruğu erişimi reddedilir.

Ücretli mod seçildiyse ayrıca gerçek sandbox satın alma → sunucu doğrulaması → admin işlem/üyelik görünümü → duplicate/geç bildirim → restore ve A/B hesap çakışması → iptal/iade/grace/expiry varyantları → mutabakat raporu çalışır. Yerel sentetik senaryo, gerçek sağlayıcı testi olarak raporlanmaz.

### 17.3 Bilinçli olarak açılmayacak işler

Android istemcisi, Health Connect okuyucusu, PWA/webview uygulama kabuğu, ayrı antrenör web ürünü ve optimize tablet/Mac sürümü P0 görevi açılmaz. P1 antrenör web tasarım notları korunur; P0 antrenör özellikleri iPhone’da uygulanır. Gerekli backend/worker/kimlik/OAuth dönüş uçları bu istemci sınırından etkilenmez. **P0 özel web admin, üyelik/ücret ve minimum CRM işleri bu yasağın dışındadır ve bu sürümde zorunludur.**

`Watch app`, `Bluetooth pairing`, `live HR streaming`, `GPS workout recorder`, `workout start/pause`, `WorkoutKit scheduling`, `device control`, `camera measurement` görevleri oluşturulmaz. Mevcut repoda varsa kapsam dışı olarak işaretlenir; diğer özellikleri bozmadan kaldırma/ayırma planı yapılır. Ölçüm kabiliyetini açık tutup yalnızca ekrandan gizlemek yeterli değildir.

### 17.4 Katalog geliştirme iş paketleri ve yayın kapısı

1. **CAT-INGEST:** Pin/hash doğrulaması; resmî kaynak sözlüklerinin tamamını staging'e çıkar; namespace ve kaynak kodlarını koru; kaynak sayımı/unknown/deprecated raporu üret. Ham SDK dosyasının dağıtım şartlarını ayrıca değerlendir.
2. **CAT-MAP:** Resmî kılavuzlardaki adlar ve uygulama türleri için alias/eşleme; canonical/method/variant ayrımı; belirsiz bağlantılarda review. Sadece model çıktısından kaynak mapping üretme.
3. **CAT-ENRICH:** Branş/örüntü/kas/aparat/stil/pozisyon gibi alanları uzman incelenmiş metadata ile doldur; TR/EN/sinonim ve özel kapsam; Garmin kategorisini otomatik kas grubu yapma.
4. **CAT-SCHEMA:** Bölüm 11.9 tipli seanslar, süre/birim/yük/ekipman/doz doğrulayıcıları; içerik inceleme ve branch capability policy; geçmiş snapshot ve v3 migration.
5. **CAT-PLAN:** Her P0 paket için minimum işlevsel, incelenmiş içerik setiyle gerçek ilk hafta ve adaptasyon; katalogda bulunup henüz teknik koçluğu onaylanmayan branşları ayrı göster.
6. **CAT-RELEASE:** Gerçek kaynak üzerinde kayıpsız extraction testi, API/UI izinleri, model/koç değerlendirmesi, diff/rollback ve yayın raporu. Sayısal eşik uydurmak yerine seçilen kaynak sürümünün gerçek toplamıyla karşılaştır.

Kaynak sözlüğünün tamamı staging'e aktarılmadan “Garmin kapsamı tamam”, HIIT/fonksiyonel/Pilates gerçek planlama testleri geçmeden “P0 çok sporlu planlama tamam” denmez. Derin teknik koçluğu henüz doğrulanmamış bir branşın varlığı, onun geçmişini içe aktarmayı veya antrenörün programına yerleştirmeyi engellemez.

## 18. Test ve kabul senaryoları

Aşağıdaki senaryolar otomatik testler ve uygun olanlarda gerçek iPhone, kaynak uygulama/hesap ve kullanıcı doğrulamasıyla kapsanır. “Geçti” sonucu sakatlık önlendiği veya sportif etkinlik bilimsel olarak kanıtlandığı anlamına gelmez.

| Test | Özellikler | Senaryo | Beklenen sonuç |
|---|---|---|---|
| T01 | PROF, DATA, PLAN | Bağlı sağlık uygulaması ve VO₂max kaydı olmayan yetişkin yeni kullanıcı | Gerekli manuel bilgilerle uygun başlangıç taslağı; uydurma VO₂max veya bpm yok. |
| T02 | GOAL, PLAN | HYROX sub-70 ve maraton sub-4, farklı tarihler/öncelikler | Hedef ilişkisi görünür; çatışma ve varsayımlar açıklanır. |
| T03 | AVAIL, PLAN | Kullanıcı sadece belirli gün/saatlerde müsait | Isınma ve dinlenmeler dahil seanslar pencereye sığar. |
| T04 | PLAN | Kısıtlar hedeflenen seansları imkânsız kılıyor | `INFEASIBLE`; gizli kısıt gevşetme veya sıkıştırma yok. |
| T05 | PLAN | Hafta ortasında kullanıcı zaten iki antrenman yapmış | Geçmiş korunur; yeni plan kalan günleri kapsar. |
| T06 | DATA, ADAPT | Aynı aktivite iki sağlık uygulaması/erişim yolundan geliyor | Tek kanonik aktivite/yük; kaynak kayıtları korunur. |
| T07 | DATA, ADAPT | Planlı idman bitişinden sonra veri geç geliyor | Veri yokluğu hemen `SKIPPED` olmaz; sonra doğru eşleşir. |
| T08 | DATA | Kuvvet kaydında yalnızca süre var | Set/tekrar/yük uydurulmaz; gerekli ayrıntı istenir. |
| T09 | DATA | Uyku ve HRV verisi bulunmuyor | Sıfır değer atanmaz; veri eksikliği görünür. |
| T10 | ADAPT | Beklenmedik basketbol veya ek alt vücut seansı | Sonraki seans ilgili bağlamla değerlendirilir. |
| T11 | ADAPT | Kullanıcı iyi uyudu ama bölgesel rahatsızlık bildirdi | İyi tek ölçüm rahatsızlık bildirimini otomatik geçersiz kılmaz. |
| T12 | ADAPT | Anahtar seans kaçırıldı, kalan hafta dolu | Otomatik telafi borcu yok; taşı/kısalt/kaldır seçenekleri. |
| T13 | AVAIL, ADAPT | Bugün 60 yerine 25 dakika ve farklı ekipman | Uygulanabilir, amacı açıklanmış alternatif veya uygun seçenek yok sonucu. |
| T14 | PLAN, ADAPT | Pazar geç biten seans, pazartesi erken seans | Haftalar arası gerçek saat farkı hesaba katılır. |
| T15 | PLAN, ADAPT | Kullanıcı saat dilimi değiştiriyor | Yerel uygunluk ve gerçek geçen süre doğru; çakışma yok. |
| T16 | AI, PLAN | Platform LLM yerine kullanıcı BYOK seçildi | Plan taslağı seçilen sağlayıcıda; aynı doğrulama motorundan geçer. |
| T17 | AI | BYOK geçersiz, kota dolu, timeout veya model reddi | Açık hata türü; sessiz sağlayıcı değişimi yok. |
| T18 | AI | Model valid JSON içinde aşırı/uygunsuz doz üretiyor | JSON geçerli olsa da politika/alan doğrulaması reddeder. |
| T19 | AI | Bağlam bütçesi yetersiz | Kritik kısıtlar kesilmez; kontrollü parçalama veya görev reddi. |
| T20 | AI | Kullanıcı modeli tool calling desteklemiyor | Uygunsa backend hazırlıklı sınırlı JSON yolu; uygun değilse görev desteklenmiyor. |
| T21 | AI, CONSENT | Kullanıcı endpoint’i değiştiriyor | Gerekli yeni alıcı izni alınmadan kişisel veri gönderilmez. |
| T22 | AI, SECURITY | Custom URL localhost, metadata veya DNS rebinding içeriyor | SSRF engellenir; yönlendirme üzerinden aşılamaz. |
| T23 | AI, SECURITY | API anahtarı hata/trace yanıtına sızmaya çalışıyor | Redaction ve secret sınırları; sızıntı testi başarısız yayını durdurur. |
| T24 | SECURITY | Aktivite adı veya antrenör notunda prompt injection | Politika/yetki değişmez; başka sporcu verisi alınamaz. |
| T25 | COACH | Antrenör onayı gerekirken sporcu veya AI yayınlıyor | Yetkisiz yayın reddedilir; onay kuyruğu kullanılır. |
| T26 | COACH | Sporcu antrenörü değiştiriyor | Geçmiş korunur; eski scope iptal, yenisi açık onayla oluşur. |
| T27 | COACH, CONSENT | Sporcu koça uyku verisi paylaşmıyor | Ham veri ve o veriyi ifşa eden açıklama/özet koça gösterilmez. |
| T28 | PLAN | İki antrenör aynı eski sürümü onaylıyor | Tek aktif sürüm; ikinci işlem çatışma/stale sonucu alır. |
| T29 | PLAN, DATA | Model çalışırken önemli yeni aktivite geldi | Eski snapshot’la taslak otomatik yayımlanmaz. |
| T30 | CONSENT, AI | Kuyruk işi çalışmadan izin iptal edildi | Dışarı veri gönderimi durur; iş iptal/izin hatası alır. |
| T31 | GUIDE, DATA | Offline kullanıcı beyanı iki kez sunucuya ulaştı | Aynı gerçek aktivite ikiye katlanmaz. |
| T32 | DATA | Kaynak aktiviteyi düzeltiyor veya siliyor | Özetler güncellenir; geçmiş kararın eski dayanağı uygun audit ile işaretlenir. |
| T33 | AI | Sağlayıcı değiştirildi | Profil/plan kaybolmaz; önceki hafta otomatik yeniden yazılmaz. |
| T34 | OPS | Aynı worker görevi tekrar çalıştı | Çift plan, ücretli gereksiz tekrar veya çift bildirim önlenir. |
| T35 | PRIVACY | Hesap silme isteği | Aktif kayıtlar, cache ve kuyruklar tanımlı akışla temizlenir; backup/dış alıcı sınırları açıklanır. |
| T36 | CONTENT | Şablon/politika/model sürümü değişti | Aktif plan sessizce değişmez; regression testleri ve gerekiyorsa kontrollü reevaluation. |
| T37 | UI, GUIDE | AI ve internet geçici olarak yok | Son onaylı seans erişilir, güncellik sınırı gösterilir; kritik durumda eski öneri yeni onay sayılmaz. |
| T38 | DATA, RIGHTS | AI kullanım hakkı olmayan kaynaktan türetilmiş özet | Özetleme kısıtı aşmaz; AI bağlamından çıkarılır. |
| T39 | AI, COACH | Koç kendi key’iyle yetkisiz sporcu verisi istiyor | Key sahipliği veri erişim yetkisi sağlamaz; istek reddedilir. |
| T40 | SAFETY | Kullanıcı ciddi/olağandışı sağlık şikâyeti bildiriyor | Otomatik yoğunlaştırma ve sıradan fallback durur; uzman incelemeli güvenlik yönlendirmesi çalışır. |
| T41 | DATA-20, GUIDE | Kullanıcı ilk kez bağlanıyor ve seans ekranını açıyor | Bluetooth, Motion, konum veya canlı workout izni istenmez; kayıt oturumu başlamaz. |
| T42 | DATA-01, DATA-20 | HealthKit izin isteği ve adapter kodu inceleniyor | Yalnızca gerekli read türleri; dış sağlık deposuna write/delete ve workout session yok. |
| T43 | DATA-13, DATA-17 | Google Health Apple Health’e desteklenen veri yazmış | Tek HealthKit yoluyla içe alınır; ayrıca cihaz bağlantısı veya sahte Google OAuth gerekmez. |
| T44 | DATA-14, DATA-23 | Google Health’te metrik var, Apple Health’e o yönde paylaşılmıyor | Metrik Sportapp’ta eksik/erişilemiyor; başka kategoriden uydurulmaz. |
| T45 | DATA-13, DATA-17 | Huawei Health → Apple Health’te yalnızca bazı kategoriler var | Gelenler kullanılır; Huawei tam veri desteği iddiası yok; eksikler görünür. |
| T46 | DATA-13, DATA-22 | iPhone kullanıcısı Samsung Health seçiyor | Doğrulanmış yol yoksa açık sınırlılık; Android SDK/Health Connect iOS API’si gibi kullanılmaz. |
| T47 | DATA-22 | Samsung’dan dolaylı zincir iddia ediliyor | Her aktarım yönü/kategori/hesap testi olmadan destek tamamlandı sayılmaz. |
| T48 | DATA-10, DATA-14 | Sync şimdi başarılı, en yeni uyku üç gün önce | “Şimdi ölçüldü” görünmez; sorgu zamanı ve olay zamanı farklıdır. |
| T49 | DATA-16 | Cursor ilerlemeden uygulama kapandı/yeniden kuruldu | Kontrollü yeniden okuma; kayıp veya ikiye katlanan aktivite yok. |
| T50 | DATA-07, DATA-18 | İki uygulama aynı adım/uyku/enerji toplamını paylaşıyor | Metrik bazlı uzlaştırma; günlük toplamlar toplanmaz. |
| T51 | DATA-08, GUIDE-02 | Kullanıcı “yaptım” dedi, dış kayıt sonra geldi | Tek kanonik aktivite; beyan ve kayıt kökenleri korunur. |
| T52 | DATA-09, DATA-21 | Read izni kapandı; kayıtlar sorguda görünmüyor | Hepsi kaynakta silinmiş sayılmaz; izin belirsizliği ve bağlantı durumu açıklanır. |
| T53 | DATA-06, AI-13 | Orijinal uygulama aktarım sırasında kaybolmuş | Köken `UNKNOWN`; LLM görünmeyen uygulama/cihazı uydurmaz. |
| T54 | GUIDE-01, PLAN | Hedef nabız reçetesi gösteriliyor | Planlanan yoğunluk etiketi var; mevcut nabız veya canlı ölçüm diye sunulmaz. |
| T55 | GUIDE-01, GUIDE-05 | Kullanıcı antrenman kartını açıp kapattı | Başladı/tamamlandı kaydı oluşmaz; ekran süresi egzersiz süresi sayılmaz. |
| T56 | DATA-02, DATA-20 | Kullanıcı gerçekleşen süreyi beyanla düzeltti | Düzeltme Sportapp’ta ayrı; dış kaynak/HealthKit kaydı değiştirilmez. |
| T57 | COACH-05, DATA-10 | Koç paneli açık; sporcu telefonu eşitlemiyor | Son paylaşılan verinin tarihi görünür; Apple Health’e uzaktan anlık erişim taklidi yok. |
| T58 | DATA-11, AI-02 | Sağlık uygulaması OAuth token’ı ve AI API key birlikte mevcut | Ayrı sırlar/kapsam; yanlış sağlayıcıya aktarım ve LLM erişimi yok. |
| T59 | DATA-14, DATA-16 | Kaynak geçmiş/silme veya webhook desteği sunmuyor | Yetenek matrisi sınırlılığı doğru; hayalî endpoint/sinyal yok. |
| T60 | DATA-16, CONSENT | Aynı iPhone’da başka Sportapp hesabına geçildi | Mevcut telefon sağlık geçmişi yeni hesaba otomatik taşınmaz; yeni açık bağlantı onayı gerekir. |
| T61 | AI, DATA-06 | Model içe aktarılmış veri eksikliğini ölçüm yaparak gidermek istiyor | Araç yok; beyan veya veri yolu kontrolü önerilir; donanım entegrasyonu başlatılmaz. |
| T62 | DATA-09, DATA-21 | Köprü eski kaydın silinmesini sonraki depoya taşımıyor | Tam otomatik silme yayılımı vaat edilmez; uzlaştırma ve Sportapp silme akışı çalışır. |
| T63 | AUTH-01, AUTH-02 | Yeni e-posta kaydı; doğrulama henüz yapılmadı | Sınırlı hesap; sağlık upload/AI/koç paylaşımı yok; doğrulamadan sonra aynı kullanıcıyla devam. |
| T64 | AUTH-02, AUTH-20 | Doğrulama linki süresi geçmiş, tekrar açılmış veya uygulama kapanmış | Tek-kullanım/süre kontrolü; güvenli yeniden gönderme ve kaldığı yerden devam; ikinci hesap yok. |
| T65 | AUTH-04, AUTH-06, AUTH-10 | Apple ilk kayıt ve relay adresi; sonraki girişte ad alanı gelmiyor | Aynı iç kullanıcı/profil korunur; adı boşaltma, ek şifre veya gerçek e-posta zorlama yok. |
| T66 | AUTH-05, AUTH-06 | Google ilk/tekrar giriş; aynı sub için e-posta değişmiş | Doğrulanmış sub ile aynı hesap; yeni e-postadan ikinci sporcu oluşturulmaz. |
| T67 | AUTH-04, AUTH-05, AUTH-20 | Aynı callback tekrar geliyor; kullanıcı sağlayıcı ekranını iptal ediyor | Idempotent işlem; duplicate hesap/oturum yok; iptal doğal şekilde giriş seçimine döner. |
| T68 | AUTH-04, AUTH-05, AUTH-22 | Token signature/audience/issuer/nonce/süre yanlış veya test audience üretime gönderildi | Kimlik doğrulama reddedilir; decode edilmiş token veya düz user ID kabul edilmez. |
| T69 | AUTH-11, AUTH-12, AUTH-13 | Refresh tekrarı, süresi dolmuş oturum ve tüm oturumlardan çıkış | Reuse/expiry politikası ve sunucu revoke; eski bearer ile sağlık erişimi yapılamaz. |
| T70 | AUTH-09, AUTH-14 | E-posta hesabına Google/Apple yöntemi ekleniyor | Mevcut hesap step-up + yeni kimlik doğrulanır; aynı User.id, plan/izin geçmişi korunur. |
| T71 | AUTH-09, AUTH-10 | Aynı e-posta veya başka hesaba bağlı sosyal subject ile giriş/bağlama | Otomatik merge/takeover yok; mevcut hesabı doğrulayan güvenli çözüm; veri birleşmez. |
| T72 | AUTH-07, AUTH-10 | Şifre sıfırlama mevcut, olmayan ve sosyal-only hesap için isteniyor | Public yanıt hesap/yöntem ifşa etmez; sosyal-only hesaba sessiz parola eklenmez. |
| T73 | AUTH-07, AUTH-08 | Reset linki iki kez veya link tarayıcısı GET ile açılıyor | GET token tüketmez; onayla tek kullanım; sıfırlama eski oturumları iptal eder. |
| T74 | AUTH-11, AUTH-22, SECURITY | Auth/health/AI token hata, URL, log veya iOS binary’sine sızıyor | Secret redaction/build kontrolleri ihlali engeller; üretim yayını durur. |
| T75 | AUTH-04, AUTH-05, AUTH-15 | P0: aynı Apple/Google hesabı iPhone sporcu/antrenör rollerinde; P1: antrenör web istemcisi açıldığında platformlar arasında kullanılıyor | P0’da tek kullanıcı ve izole rol kapsamları; P1’de ayrıca doğru client gruplaması. Rol veya platform değişimi yeni/izinsiz sağlık erişimi açmaz. |
| T76 | AUTH-15, COACH | Kullanıcı API payload’ıyla role=ADMIN veya başka athlete_id gönderiyor | Backend rol/nesne yetkisi reddeder; kullanıcı rol tercihi sağlık erişimi yaratmaz. |
| T77 | AUTH-16, CONSENT-11 | Davet linki yeni kullanıcıda, yanlış hesapta, süresi dolmuş veya kullanılmış | Güvenli giriş sonrası doğru ilişki ve açık kapsam onayı; tekrar/yanlış hesaba erişim yok. |
| T78 | AUTH-04, AUTH-05, CONSENT-01 | Apple/Google ile login tamamlandı ama sağlık izni verilmedi | Sağlık sorgusu/upload başlamaz; login token’ı veri hesabı yetkisi sayılmaz. |
| T79 | CONSENT-02, CONSENT-06 | Kullanıcı bütün sağlık bağlantılarını atlıyor veya izin reddediyor | Hedef/uygunluk/manuel bağlam ve hesap erişimi açık; uydurma geçmiş veya izin baskısı yok. |
| T80 | CONSENT-03, CONSENT-04 | Sadece antrenman/nabız kategorileri seçildi | Sadece gerekli read türleri; sleep/beslenme ve tüm write türleri yok; Info.plist amacı doğru. |
| T81 | CONSENT-04, CONSENT-06 | HealthKit request tamamlandı=true ama görünür kayıt yok | Tüm izinler granted denmez; NO_VISIBLE_DATA/UNKNOWN ile kaynak/izin rehberi gösterilir. |
| T82 | CONSENT-05, DATA-17 | Google/Huawei Apple Health paylaşımı kapalı; Sportapp read açık | Köprüde ayrı eksik adım açıklanır; otomatik tam bağlantı başarısı veya sahte OAuth yok. |
| T83 | CONSENT-07, CONSENT-12 | OS read var ama backend aktarım/onay kapsamı yok veya süresi doldu | Backend’e sağlık payload’ı çıkmaz; sunucu uygun hata ve izin adımı döner. |
| T84 | CONSENT-16, AUTH-12, DATA-16 | A hesabından başlayan batch/callback B hesabına geçtikten sonra geliyor | Eski binding/epoch reddedilir; A verisi, anchor, plan, bildirim ve offline beyan B’ye taşınmaz. |
| T85 | CONSENT-09, CONSENT-13, AI | İzin kuyrukta iptal edildi veya AI gönderimi başladıktan sonra kaldırıldı | Yeni gönderim yok; gönderilmiş sonuç kullanılmaz/karantinaya alınır; geri alınmış gibi söylenmez. |
| T86 | CONSENT-08, CONSENT-11 | Uyku paylaşımı koçtan kaldırıldı ama eski AI brifingi uyku detayı içeriyor | Ham alanla birlikte ifşa eden türev/cache de kapanır; izinli bağlamla yeni brifing. |
| T87 | CONSENT-17, DATA-11 | P1 Google Health OAuth hesabı, login hesabı ve BYOK anahtarı farklı | Ayrı kimlik/connection/secrets; gerçek scope/test sorgusu; login hesabı sessiz değişmez. P1 gerçek test erişime bağlıdır. |
| T88 | AUTH-12, CONSENT-09 | Normal logout, veri hesabını disconnect ve hesap silme sırayla deneniyor | Üç ayrı etki; logout bağımsız OAuth grant’i körlemesine revoke etmez; disconnect hesabı silmez. |
| T89 | AUTH-09 | Kullanıcı son login yöntemini kaldırmaya çalışıyor | Doğrulanmış alternatif veya açık silme yolu; hesaptan kilitlenme yok. |
| T90 | AUTH-18, CONSENT-09 | Apple ile açılmış hesap uygulama içinden siliniyor; provider revoke geçici hata veriyor | Yeni işler/erişim durur, revoke tekrar edilir; dış sağlık kayıtları değişmez; durum dürüstçe gösterilir. |
| T91 | AUTH-18, AUTH-20 | Silinen hesapla aynı sosyal kimlik yeniden kayıt oluyor | Yeni izin/onboarding; silinmiş sağlık geçmişi, eski key ve koç scope’u geri gelmez. |
| T92 | AUTH-10, AUTH-22 | Apple relay adresine doğrulama/güvenlik e-postası; forwarding kapalı | Gönderici/relay gerçek test; teslim sorunu giriş kimliğini silmez; yeni gerçek adres zorlanmaz. |
| T93 | AUTH-14, AUTH-19 | Eski oturumla export/kimlik değişimi; MFA’sız platform yönetici erişimi | İşleme bağlı step-up/MFA gerekir; Google login var diye ikinci faktör varsayılmaz. |
| T94 | CONSENT-18 | Bildirim izni reddedildi; Google login sırasında takvim/sağlık isteniyor | Bildirim olmadan plan açık; login minimum identity kapsamı; gereksiz scope/izin reddedilir. |
| T95 | AUTH-15, CONSENT-11 | Yalnızca antrenör modunda kullanıcı ilk giriş yapıyor | Kendi HealthKit izni istenmez; müşteri verisi sadece kabul edilmiş paylaşım kapsamında görünür. |
| T96 | AUTH-17, AUTH-22 | Apple signed notification tekrar/sahte; anahtar rotasyonu veya credential revoked | İmza/issuer/tekrar kontrolü; doğru olay etkilenen yöntemi/oturumu kapatır; key rotation kontrollü. |
| T97 | AUTH-08, AUTH-10 | İletişim e-postası değiştiriliyor veya public endpoint’ten yöntemler sorgulanıyor | Yeni adres teyidi/step-up; provider sub sabit; hesap/yöntem keşfi açık edilmez. |
| T98 | CONSENT-12, CONSENT-14 | Yeni beslenme kategorisi, yeni AI endpoint veya yeni koç eklendi | Eski izin kapsamı genişlemez; fark/onay; ret eski izinli işlevleri kapatmaz. |
| T99 | CONSENT-07, CONSENT-16, SECURITY | İstemci başka athlete_id, sahte GRANTED veya seçilmemiş kategoriyle batch gönderiyor | Sunucu binding/actor/kategori/tarih/izin kontrolüyle reddeder; istemci beyanı OS kanıtı değildir. |
| T100 | AUTH-22, OPS | Mock login/fake permission tamamlandı ekranı üretim yapılandırmasına girdi | Build/config/test kapısı yayını engeller; gerçek sağlayıcı/izin doğrulaması olmadan done denmez. |
| T101 | SPORT-01, SPORT-07, PROF-01 | Kullanıcı yalnızca Pilates ve mobilite yapıyor; yarış hedefi yok | Koşu/HYROX seçmeye veya VO₂max girmeye zorlanmadan profil, haftalık plan ve geri bildirim döngüsü çalışır. |
| T102 | SPORT-01, SPORT-37, PLAN-02 | Pilates + kuvvet + yüzme hedefleri aynı haftada | Her branş kendi seans şemasıyla, ortak zaman bütçesinde ve ilgili deneyim/kısıtlarla planlanır. |
| T103 | SPORT-03, SPORT-31 | Pinlenmiş resmî profil tüm enum tablolarıyla içe aktarılıyor | Kaynak satır sayılarıyla çıktı karşılaştırılır; sport/sub_sport/category ve bütün exercise-name tablolarında kayıp yok; sayılar tür bazında raporlanır. |
| T104 | SPORT-03, SPORT-31 | Aynı profili ikinci kez veya paralel seed işiyle yükleme | Aynı sürüm/source key tekil; kullanıcı içeriği ve geçmiş plan değişmez; import atomik/idempotent olur. |
| T105 | SPORT-31 | Beklenen sürüm/hash uyuşmuyor veya sözlükte tekrar anahtar var | İş başarısız/staging'de kalır; eksik sözlük üretime yayımlanmaz; hata kaynağı görünür. |
| T106 | SPORT-03, SPORT-25 | İki exercise_category içinde aynı exercise code bulunuyor | Bileşik kaynak kimliği çakışmaz; iki hareket otomatik birleşmez. |
| T107 | SPORT-31, SPORT-34 | Kaynakta generic/unknown/all veya deprecated değer var | Ham değer korunur; gerçek reçete hareketi gibi otomatik seçilmez; deprecated durumuna geçmiş çözümleme devam eder. |
| T108 | SPORT-03, SPORT-31 | Yeni exercise-name tablosu var ama kategori eşlemesi bulunamıyor | Kayıt atılmaz; unresolved raporu üretilir; kategori/kas grubu uydurulmaz. |
| T109 | SPORT-04, SPORT-38 | Garmin menü adı FIT spor koduyla birebir eşleşmiyor | Menü adı ve model/sürüm kanıtı ayrı tutulur; FIT kodu uydurulmaz; mapping statüsü açıklanır. |
| T110 | SPORT-04 | Aynı Garmin aktivitesi iki menü kategorisinde yer alıyor | Tek kanonik disipline birden çok gezinme ilişkisi kurulabilir; aktivite/kapsama sayısı şişirilmez. |
| T111 | SPORT-05 | Fonksiyonel veya reformer varyantı için resmî Garmin kodu yok | Sportapp namespace kullanılır; 'Garmin'den aktarıldı' etiketi verilmez; kullanıcı kendi branşında plan yapabilir. |
| T112 | SPORT-08, SPORT-09 | Kullanıcı sırt → yatay çekiş → dumbbell → tek kol arıyor | Filtreler birlikte çalışır; yalnızca kaynakta 'row' kategorisi var diye tüm kas bölgeleri eşit atanmaz. |
| T113 | SPORT-08, SPORT-36 | Bir hareket çoklu birincil/ikincil kas ve iki sporla ilişkilidir | Tek kategoriye sıkıştırılmaz; filtrelerde bulunur; tekrar sayım ve anlam kaybı olmaz. |
| T114 | SPORT-27, SPORT-36 | Türkçe 'sırt', İngilizce 'back' veya onaylı sinonimle arama | Aynı ilgili kanonik içerik bulunur; resmî kod değişmez; çeviri durumu ve ad kaynağı ayrı kalır. |
| T115 | SPORT-12, SPORT-21 | Mat Pilates kullanıcısına haftalık seans üretimi | Mat uyumlu hareket/pozisyon/seri ve tekrar-tutuş-süre alanları; barbell/tempo veya nabız zorunluluğu yok. |
| T116 | SPORT-09, SPORT-12 | Reformer cihazı/ayar bilgisi yok; iki markanın yay rengi aynı | Model evrensel kg veya yay eşdeğerliği üretmez; aparat uyumlu uzman onaylı içerik/onay akışı kullanılır. |
| T117 | SPORT-10, SPORT-21 | EMOM ve AMRAP blokları üretiliyor | EMOM süre pencereleri ve tur yapısı; AMRAP zaman sınırı doğru hesaplanır; planlanan tekrar gerçekleşen tekrar sayılmaz. |
| T118 | SPORT-10, SPORT-22 | Kaynak uygulama seansı 'HIIT' diye etiketlemiş ama ayrıntı yok | Etiket korunur; gerçek yoğunluk, interval yapısı ve hareketler kesinmiş gibi türetilmez. |
| T119 | SPORT-11, SPORT-24 | Fonksiyonel antrenmanda taşıma/hinge/çekiş blokları | Hareket örüntüsü ve amaç bazlı plan; tek genel kardiyo metnine dönüşmez; ekipman/kısıt kontrolü var. |
| T120 | SPORT-13, SPORT-21 | Yoga akışı, poz tutuşu ve geçiş süresi | Doz/akış şeması uygun; güç/tempo/1RM alanları istenmez; süreye geçişler dahil edilir. |
| T121 | SPORT-14, PROF-04 | Omuz mobilitesi tercihi ve kullanıcı kısıtı birlikte var | Kısıtlı hareketler otomatik seçilmez; tıbbi tanı/rehabilitasyon vaadi verilmez. |
| T122 | SPORT-15, SPORT-21 | 25 m ve 50 m havuzda yüzme intervali, yarda seçimi | Havuz uzunluğu/stil/drill ve birimler doğru; koşu temposu yüzme hedefi diye kopyalanmaz. |
| T123 | SPORT-15, SPORT-22 | Kullanıcıda koşu nabız bölgeleri var, bisiklet referansı yok | Koşu referansı bisiklet bölgesi diye kesin kullanılmaz; dayanak/eksikliği gösteren uygun yönlendirme verilir. |
| T124 | SPORT-16, AVAIL-01 | Sabit tenis dersi veya takım maçı haftaya ekleniyor | Randevu ve partner/tesis koşulları korunur; rutin gibi otomatik taşınmaz; drill/maç tipi ayrı kalır. |
| T125 | SPORT-17, SPORT-33 | Dans koreografisi/dövüş round'u; ileri teknik içerik onaysız | Tipli seri/round/ders şeması kullanılabilir; uzmanlık sınırı uygulanır; onaysız ileri teknik reçete üretilmez. |
| T126 | SPORT-18, SPORT-33 | Dalış, jumpmaster veya yüksek riskli teknik profil içe geldi | Kaynak türü tanınır; katalogda var diye otomatik dekompresyon/nefes tutma/teknik güvenlik reçetesi verilmez. |
| T127 | SPORT-19, PROF-04 | Handcycle veya oturarak hareket tercih eden kullanıcı | Koşu/ayakta yapma varsayımı dayatılmaz; uygun beceri/ekipman/kısıtla içerik ve tercih korunur. |
| T128 | SPORT-20, DATA-07 | Karışık seans ana kayıt ve üç alt kayıtla farklı uygulamalardan geldi | Ebeveyn-alt parça bağı korunur; çakışan süre/mesafe/enerji iki kez toplanmaz. |
| T129 | SPORT-23, SPORT-37, ADAPT-03 | Plansız basketbol sonrası kuvvet/Pilates haftası uyarlanıyor | Gerçek zaman aralığı, bildirilen bölgeler ve branş amacı değerlendirilir; tüm aktivite koşu km'ye çevrilmez. |
| T130 | SPORT-26, DATA-23 | Apple Health'te yalnızca '45 dk Pilates' özeti var | Yapılan hareketler, tekrarlar, reformer ayarı veya teknik kalite uydurulmaz; izinli kısa beyan yalnızca eksikse sorulur. |
| T131 | SPORT-25, DATA-06 | Kaynakta bilinmeyen yeni spor veya belirsiz 'Other' etiketi | Orijinal kayıt korunur; unclassified/broader mapping açıklanır; kullanıcı düzeltmesi kaynak veriyi değiştirmez. |
| T132 | SPORT-25, SPORT-32 | Kullanıcı geçmiş tür eşlemesini düzeltiyor | Kaynak ham kayıt değişmez; açıklamalı yeni kanonik yorum sürümü oluşur; ilgili gelecek plan kontrollü değerlendirilir. |
| T133 | SPORT-06, SPORT-12 | İleri seviye koşucu Pilates'e ilk kez başlıyor | Genel fitness geçmişi branş becerisi yerine geçmez; uygun başlangıç/uzman inceleme ve ekipman koşulları uygulanır. |
| T134 | SPORT-24, ADAPT-05 | Kullanıcı squat yerine rastgele aynı kası çalıştıran hareket istiyor | Amaç, beceri, yük biçimi ve kısıt denetlenir; kas etiketi tek başına eşdeğer sayılmaz. |
| T135 | SPORT-28, PLAN-05 | Kullanıcı bir branşı dışlıyor, bir hareketi yasaklıyor ve dersi kilitliyor | AI taslağı ve manuel değişiklik aynı kısıtları uygular; uygun plan yoksa açıklama verir. |
| T136 | SPORT-29, SPORT-34 | LLM katalogda bulunmayan hareket ID'si veya incelemesiz varyant döndürüyor | Doğrulama reddeder; modele doğru adaylar verilebilir; sahte ID otomatik kataloğa yayımlanmaz. |
| T137 | SPORT-30, COACH-07 | Antrenör A'nın özel drill/şablonunu B veya başka sporcu arıyor | İçerik tenant/scope filtresinden geçer; prompt ile bulunamaz; global katalogda görünmez. |
| T138 | SPORT-30, COACH-09, COACH-10 | Sporcu antrenör değiştiriyor; geçmişte özel içerikli seans var | Sporcuyla paylaşılmış reçete snapshot'ı izinle korunur; eski koçun tüm özel kütüphanesi devredilmez. |
| T139 | SPORT-32 | Bir hareketin Türkçe adı, kas haritası veya şeması güncellendi | Eski planın içerik sürümü/snapshot'ı korunur; geleceğe etkisi ayrı değişiklik olarak değerlendirilir. |
| T140 | SPORT-29, SPORT-32 | Daha önce onaylanan içerik güvenlik nedeniyle geri çekildi | Yeni reçetelerde engellenir; etkilenmiş gelecek planlar inceleme kuyruğuna alınır; geçmiş silinmez. |
| T141 | SPORT-33, SPORT-37 | P0 yayında HIIT/fonksiyonel/Pilates yalnızca seçim kutusu olarak var | Yayın kriteri karşılanmaz; gerçek tipli plan, değişiklik, ekipman ve seans geri bildirim testleri gerekir. |
| T142 | SPORT-34, AI-06, AI-08, CONSENT-10 | Platform LLM ve BYOK aynı çok sporlu senaryoyu işliyor | Her ikisi ilgili onaylı katalog altkümesi ve aynı doğrulayıcıyla çalışır; başka modele izinsiz fallback yok. |
| T143 | SPORT-35, SPORT-39 | Garmin animasyonu veya lisansı belirsiz medya yükleniyor | Hak belgesi olmadan yayın engellenir; kaynakta hareket adı olması medya kullanım hakkı sayılmaz. |
| T144 | SPORT-38, SPORT-40 | Yeni kaynak sürümü yeni/çıkarılmış türler içeriyor | Diff/sayım ve mapping-review raporu; üretime insan onayı; FIT/menü/kanonik/onaylı içerik sayıları ayrı. |
| T145 | SPORT-03, AUTH-01, AUTH-04, AUTH-05, CONSENT-01, DATA-20 | Yeni katalog ve spor seçimi yayınlandı; uygulama izinleri tekrar inceleniyor | Apple/Google/e-posta akışları ve izin ayrımı korunur; Garmin login/cihaz/sensör/yazma izni eklenmez; bütün v3 regresyonları çalışır. |
| T146 | IOS-01, IOS-08 | P0 yalnızca web antrenör paneliyle tamamlanmış gösteriliyor | P0 reddedilir; aynı native iPhone uygulamasında COACH akışları gerekir. |
| T147 | IOS-02, IOS-07 | iPhone 12 mini’de onboarding, hafta editörü ve onay açılıyor | Küçük ekran/klavye/büyük yazıda bütün eylemler ulaşılabilir; yatay kesilme yok. |
| T148 | IOS-02, IOS-20 | iPhone 12, Pro ve Pro Max ile farklı sonraki model aileleri seçiliyor | Model/OS kurulabilir eşleşmesi kayıtlı; tek yeni Pro testi bütün aileye kanıt sayılmaz. |
| T149 | IOS-03 | iOS 14.x kullanımı için yalnızca deployment ayarı 14 yazılmış | OPEN_PLATFORM_GAP sürer; destekli araç/bağımlılık/dağıtım/gerçek test olmadan pass yok. |
| T150 | IOS-03, IOS-06 | Geliştirici rahatlık için minimumu iOS 17’ye yükseltiyor | CI/inceleme kapısı değişikliği durdurur; açık kapsam kararı olmadan kabul edilmez. |
| T151 | IOS-04 | Yeni iPhone için çıkışından önceki bir iOS test ediliyor | NOT_INSTALLABLE; destek açığı/başarısız ürün testi sayılmaz, sahte kombinasyon üretilmez. |
| T152 | IOS-04, IOS-20 | Belirli eski iOS runtime’ı mevcut Xcode’da yok | BLOCKED_TEST_ENV; ayrı destekli runner/cihaz kanıtı gerekir, skip→pass yapılmaz. |
| T153 | IOS-05 | Yeni navigation/state API’si yalnızca yeni OS’de var | Eski destekli OS’de işlevsel navigation/onay alternatifi çalışır; açılış crash’i yok. |
| T154 | IOS-05, IOS-13 | Yerel depo koşulsuz SwiftData ile geliştirilmiş | Eski hedef OS kapsamı karşılanmaz; uyumlu repository veya onaylı kapsam kararı gerekir. |
| T155 | IOS-06, AUTH-05 | Google Sign-In veya geçişli paket minimum OS’si artıyor | Pin/bağımlılık fark raporu ve uyumluluk kapısı; güvenlik ve destek birlikte değerlendirilir. |
| T156 | IOS-07 | En büyük Dynamic Type, VoiceOver ve Türkçe uzun metin kullanılıyor | Giriş, izin ret/kabul ve plan onayı okunabilir/erişilebilir; tek renk/gesture’a bağlı değil. |
| T157 | IOS-08, COACH-01 | Antrenör telefondan müşteri seçip plan düzenliyor | Yetkili sporcunun geçmişi, katalog, blok editörü, brifing ve onay native çalışır. |
| T158 | IOS-08, CONSENT-16 | Antrenör kendi sporcu modu ile müşteri modu arasında geçiyor | Kendi HealthKit binding’i müşteriye aktarılmaz; cache ve başlık doğru hesabı gösterir. |
| T159 | IOS-09 | Google/Huawei uygulamasının yeni sürümü daha yeni OS istiyor | Yalnızca ilgili bağlantı kısıtı açıklanır; Sportapp profili/manuel bağlam/izinli geçmiş çalışır. |
| T160 | IOS-10 | Eski OS’de bulunmayan HealthKit veri türü geliyor veya isteniyor | UNAVAILABLE_ON_OS/unknown raw type korunur; crash, sıfır değer veya sahte izin yok. |
| T161 | IOS-10, CONSENT-04 | Desteklenen her OS kolunda sağlık bağlantısı açılıyor | Yalnızca mevcut gerekli read türleri istenir; toShare boş ve gerçek izin davranışı testlidir. |
| T162 | IOS-11 | Telefon kilitliyken sağlık verisine erişilemiyor | WAITING_FOR_PROTECTED_DATA; izin iptal/başarılı boş geçmiş sayılmaz, sonra güvenli retry. |
| T163 | IOS-11 | Düşük güç veya background refresh kapalı/force-quit var | Tam zamanlı eşitleme vaat edilmez; son veri ve sonraki foreground yenilemesi doğru. |
| T164 | IOS-12 | Büyük ilk veri aktarımında süreç kapanıyor veya ağ kopuyor | Batch/cursor/checkpoint idempotent; tekrar yük ve bütün geçmişi baştan RAM’e alma yok. |
| T165 | IOS-12, CONSENT-13 | Aktarım kuyruğu sürerken izin geri çekiliyor veya hesap değişiyor | Eski epoch/kapsam batch’i kabul edilmez; yeni hesaba sağlık verisi sızmaz. |
| T166 | IOS-13 | Uygulama güncellemesi sırasında eski cache/plan şeması var | Migration sonrası snapshot ve outbox korunur; bozuk migration kontrollü geri kazanılır. |
| T167 | IOS-13, AUTH-12 | Silip yeniden kurma veya telefona yedekten dönüş yapılıyor | Eski sır/oturum/sağlık binding’i otomatik farklı hesaba bağlanmaz; yeniden doğrulama gerekir. |
| T168 | IOS-14, SPORT-36 | Tam katalog ve uzun geçmiş iPhone 12’de açılıyor | Sayfalı arama/özet, ölçülmüş açılış/bellek bütçesi; render sunucu LLM gecikmesinden ayrıdır. |
| T169 | IOS-15 | iPhone 12’de platform LLM veya BYOK ile haftalık plan isteniyor | Apple Intelligence/yerel model şartı olmadan backend gateway ve ortak doğrulama çalışır. |
| T170 | IOS-15 | AI işi sürerken iOS uygulaması kapanıp tekrar açılıyor | Aynı job sonucu alınır; yinelenen ödeme/plan yayını yok; yeni izin/veri ile stale kontrolü. |
| T171 | IOS-16, AUTH-04, AUTH-05 | Apple/Google dönüşü cold start, warm start ve iptalde deneniyor | Nonce/state/transaction aynı hesaba bağlı; yarım hesap, iki profil veya yanlış rota yok. |
| T172 | IOS-16, AUTH-07 | Şifre sıfırlama/coach davet linki eski OS’de açılıyor | Güvenli native dönüş ve iptal/expired akışı; hassas işlem sadece link GET’iyle uygulanmaz. |
| T173 | IOS-17, DATA-20 | Release archive entitlement ve privacy manifest inceleniyor | Ölçüm/BLE/GPS/yazma/workout recording yok; read amaçları ve gerekli SDK beyanları doğru. |
| T174 | IOS-18 | Bildirim reddi, APNs token değişimi ve logout test ediliyor | Çekirdek planlama devam eder; eski hesaba push gitmez; kilit ekranında sağlık detayı yok. |
| T175 | IOS-19 | Backend yeni seans bloğu veya katalog enum’u gönderiyor | Ham/snapshot kaybolmaz; anlamı görünmeyen değişiklik sessizce onaylatılmaz. |
| T176 | IOS-20, IOS-21 | Eski runner’ın test build’i geçti, release archive farklı SDK ile üretildi | İkisi ayrı kanıt; gerçek dağıtım adayı ayrıca doğrulanmadan eski OS geçti denmez. |
| T177 | IOS-21 | Mağaza SDK/min OS/entitlement veya privacy şartı değişmiş | Yayın öncesi güncel resmî gereksinim yeniden kontrol; yalnızca eski dokümanla onay yok. |
| T178 | IOS-22 | Yeni iPhone modeli veya beta/kararlı iOS sürümü geliyor | Unknown model sert bloklanmaz; beta/test edilmedi ve kararlı destek kanıtı ayrıdır. |
| T179 | IOS-23 | Eski OS kolu kaldırılıyor; cihaz önerilen yeni sürümü yükleyemiyor | Bildirim/onaylı süre/alternatif veri-silme yolu; sonsuz güncelleme kilidi yok. |
| T180 | IOS-24, SPORT, AUTH, CONSENT, AI | v5 temelinin tarihsel v4 regresyon kapsamı kontrol ediliyor | 170 önceki ID ve 145 senaryo korunur; 24 platform ID/35 senaryo ekli; gerçek iOS testleri yapılmadıysa açıkça NOT_RUN. |
| T181 | ADMIN-01, IOS-01 | Yalnız native iPhone ve admin API teslim edilmiş; tarayıcı UI yok | P0 tamamlanmaz; gerçek admin paneli gerekir, native COACH işi de korunur. |
| T182 | ADMIN-02, ADMIN-03 | Normal kayıtlı üye/admin route, değiştirilmiş rol payload veya kişisel token ile erişiyor | Personel üyeliği/MFA/audience/izin yoksa reddedilir; menü gizlemek yetmez. |
| T183 | ADMIN-02, AUTH-19 | İlk sahip bootstrap/davet, MFA enrollment ve kurtarma deneniyor | Tek kullanımlık güvenli akış; sabit parola yok; recovery audit’i ve eski oturum iptali. |
| T184 | ADMIN-03, ADMIN-05, ADMIN-08 | Kullanıcı kartında destek/finans alanları açılıyor; destek rolü fiyat/rol değiştirmeye veya finans raporuyla sağlık okumaya çalışıyor | Yalnız yetkili idari alanlar görünür; alan/eylem/scope kontrolü izinsiz çağrıyı reddeder; OWNER bile otomatik sağlık/anahtar erişimi kazanmaz. |
| T185 | ADMIN-03, ADMIN-13 | Personelin yetkisi export kuyruğa girdikten veya tarayıcı açıldıktan sonra kaldırılıyor | Yeni API/iş/indirme tekrar yetki kontrolüyle durur; önbellekten kaçış yok. |
| T186 | ADMIN-03 | Son OWNER siliniyor ya da iki admin aynı rol değişikliğini onaylıyor | Son sahip koruması ve optimistic concurrency; yetki yükseltme yok. |
| T187 | ADMIN-04, CRM-01 | Tek kullanıcı Apple/Google yöntemleri ve sporcu/antrenör rolleriyle kayıtlı | Kullanıcı/CRM tekil; sosyal identity sayısı kayıt/üye sayısını şişirmez. |
| T188 | ADMIN-06, BILL-13 | Admin hesabı askıya alıyor/geri açıyor; kullanıcıda mağaza aboneliği var | Gerekçe/audit ve oturum sınırı; mağaza iptal edilmiş veya ödeme iade edilmiş denmez. |
| T189 | ADMIN-14, CRM-04 | CSRF isteği, kullanıcı notunda script ve yetkisiz URL nesne erişimi deneniyor | Güvenli cookie/CSRF/render ve nesne/alan kontrolü; hassas cache yok. |
| T190 | ADMIN-12, CRM-08 | CSV not hücresinde formül var; link başka kullanıcıyla veya süresi dolunca açılıyor | Formül yürütmez; indirme scope/süre kontrolü, satır/alan minimizasyonu ve audit. |
| T191 | ADMIN-07, BILL-10 | Dashboard boş, gecikmiş, sandbox ve farklı para birimli veriler içeriyor | Gerçek sıfır/bilinmiyor/STALE ayrı; sandbox dışarıda; currency ayrı; sahte net gelir yok. |
| T192 | ADMIN-09, AI-02 | BYOK sağlayıcı maliyeti raporlanmıyor; platform maliyeti mevcut | BYOK harcaması bilinmiyor; Sportapp gelirine yazılmaz; secret/prompt gösterilmez. |
| T193 | ADMIN-10, CONSENT | Admin varsayılan LLM’i başka alıcıya değiştiriyor | Yeni alıcı/amaç onayı olmadan sağlık gönderimi yok; ücretli kullanıcı olmak onay sağlamaz. |
| T194 | ADMIN-11, SPORT | Admin katalog importer/review/publish kullanıyor | İlgili içerik scope’u, sürüm, lisans/review ve geri alma korunur; ham SDK telefona eklenmez. |
| T195 | BILL-01, BILL-14 | FREE modla ilk sürüm açılıyor; paket fiyatı henüz belirlenmemiş | Üyelik/CRM çalışır; otomatik tahsilat/paywall/borç yok; ödeme kanalı NOT_CONFIGURED ve karar açık. |
| T196 | BILL-01, BILL-06 | Panelde fiyat değişti ama App Store ürünü/fiyatı hazır değil | Yerel fiyat mağazayı değiştirmiş sayılmaz; gerçek kanal fiyatı/koşulu veya satış hazır değil görünür. |
| T197 | BILL-05, BILL-06 | Kullanıcı paid=true, başka uygulama/bundle işlemi, geçersiz imza veya test ortamı gönderiyor | Sunucu doğrulaması reddeder; gerçek prod erişimi/gelir verilmez. |
| T198 | BILL-05, BILL-09 | Aynı işlem client kanıtı ve tekrar webhook ile birkaç kez ulaşıyor | Tek transaction/finans olayı ve tutarlı tek hak; tekrar para/kota/bildirim yok. |
| T199 | BILL-08, BILL-09 | Refund/revocation sonrası eski yenileme olayı geliyor; bildirim kaybı var | Geliş sırasına göre geri açılmaz; güncel provider sorgusu ve mutabakatla uzlaşır. |
| T200 | BILL-05, AUTH-12 | Satın alma A hesabında başlıyor, sonuç gelmeden B hesabına geçiliyor | Geç callback/restore B’ye hak taşımaz; sahiplik çakışması ve güvenli destek, sağlık/kimlik birleşmez. |
| T201 | BILL-06, IOS-13 | Satın alma bekliyor/iptal; uygulama veya ağ kapanıyor; geri yükleme yapılıyor | İşlem pending/iptal durumu açık; yeniden para çekmeden doğru hesabın doğrulanmış hakkı geri gelir. |
| T202 | BILL-02, BILL-08 | Kullanıcı yenilemeyi kapatıyor ama ödenmiş dönem devam ediyor | Auto-renew off ayrı; valid_until’a kadar ilgili erişim korunur, hemen EXPIRED olmaz. |
| T203 | BILL-02, BILL-13 | Yenileme başarısız; provider geçerli grace veya retry bildiriyor | Kanal mapping’ine göre erişim; başarısız deneme gelir veya otomatik borç değildir. |
| T204 | BILL-07, BILL-10 | Kaynak tutar ölçeği farklı, birden çok currency ve vergi/komisyon eksik | Exact money/scale; kör /100 ve float yok; currency toplamları ayrı; bilinmeyen net tutar uydurulmaz. |
| T205 | BILL-08, BILL-11 | İade isteniyor; sağlayıcı admin’den refund/cancel desteklemiyor | UNSUPPORTED_ACTION veya resmî yönlendirme; talep tamamlanmış iade sayılmaz; belge yasal fatura sanılmaz. |
| T206 | BILL-12, BILL-03 | Yetkili kullanıcıya süreli ücretsiz telafi erişimi veriyor | Gerekçe/aktör/bitiş/audit ve hak; 0 satış, role/data consent değişimi yok. |
| T207 | BILL-12, BILL-14 | Personel iOS dijital satışını manuel banka paid işaretiyle açmaya çalışıyor | Onaylı kanal kuralı yoksa reddedilir; App Store’u aşan mekanizma oluşturulmaz. |
| T208 | BILL-03, BILL-13 | Üyelik sona eriyor; kullanıcı geçmiş, kendi verisi, izin iptali ve hesap silme istiyor | Bu akışlar ödeme duvarına takılmaz; yalnız policy’deki yeni ücretli işler kısıtlanır. |
| T209 | BILL-03, ADMIN-09 | Paralel iki AI işi kalan tek kotayı kullanıyor veya server arızası oluşuyor | Sunucuda atomik rezervasyon/idempotency; fazla kullanım ve çifte ücret yok; başarısız iş politikası uygulanır. |
| T210 | BILL-04, BILL-09 | Geçerli ama eşleştirilemeyen ödeme geliyor; admin provider durumunu yeniden sorguluyor | İşlem kaybolmaz, UNMATCHED/ref/sorumlu; yetkili kanıtla eşlenir; elle gerçek başarı taklidi yok. |
| T211 | BILL-14, IOS-03 | Ücretli dijital özellik açılacak; storefront/SDK/restore testleri tamam değil | Satış açılışı bloklanır; ücretsiz/admin geliştirme sürer; iOS tabanı sessizce yükselmez. |
| T212 | CRM-01, CRM-08 | Backfill ve yeni kayıt event’i aynı anda; silinen üye için eski event tekrar geliyor | Unique kart ve deletion tombstone; silinen hesap/CRM kendiliğinden geri oluşmaz. |
| T213 | CRM-02, AUTH-10 | CRM iletişim bilgisi veya etiket değişiyor; Apple relay adresi var | AuthIdentity/e-posta doğrulaması veya üyelik/rol değişmez; gerçek adres zorlanmaz. |
| T214 | CRM-03, CRM-08 | Uyku/HRV/yorgunluk veya hedeflerden satış segmenti/puan isteniyor | Genel CRM/pazarlama erişimi reddedilir; sağlıkla ticari filtreler birleşmez. |
| T215 | CRM-04, CRM-06 | Destek personeli iç not yazıyor ve kullanıcıya yanıt gönderiyor | Ayrı tür/izin/açık önizleme; iPhone’da yalnız kendi case ve public reply, iç not/koç notu yok. |
| T216 | CRM-05, CRM-07 | Görev son tarihi, personel ataması ve manuel temas kaydı değişiyor | Geciken/sorumlu görünümü; tek reminder; manuel not gönderildi/teslim edildi sayılmaz. |
| T217 | CRM-06, CRM-08 | Üyeliği biten kullanıcı destek mesajına hassas sağlık metni yazmış | Destek erişimi sürer; minimizasyon, dar yetki/redaksiyon/retention; genel CRM sağlık deposu olmaz. |
| T218 | CRM-08, BILL-11, AUTH-18 | Aktif provider aboneliği ve mali kayıt olan hesap siliniyor | Sağlık/CRM temizliği; zorunlu minimum mali saklama ayrı; sağlayıcı aboneliği otomatik iptal edilmiş denmez. |
| T219 | ADMIN-14, IOS-01, IOS-02 | Admin desktop tarayıcı ve native iPhone 12/mini rollerinde aynı veri güncelleniyor | Güvenli API şeması, TR/EN/erişilebilir web ve native akışlar; admin P0, antrenör web P1 ayrımı korunur. |
| T220 | ADMIN, BILL, CRM, IOS-24 | v6 paketi v5 gereksinimleri ve gerçek uygulama testleriyle karşılaştırılıyor | 194 önceki özellik ID ve 180 senaryo korunur; 36 özellik/40 senaryo ekli; gerçek web/iOS/ödeme testleri yapılmadıysa NOT_RUN. |

**v6 test durumları:** T181–T220 yeni admin/CRM/ücret senaryolarıdır. Satışa bağlı senaryo yalnız BILLING-001 ile açıkça ücretsiz yayın seçilmişse gerekçeli `NOT_APPLICABLE_FOR_FREE_MODE` olabilir; gerçek ücret alınacakken bu kaçış kullanılamaz. Erişim yoksa `BLOCKED_EXTERNAL`, test koşulmadıysa `NOT_RUN`; hiçbiri PASSED değildir. Belge doğrulaması, sentetik importer testi, web uygulaması testi, iPhone testi ve provider sandbox testi ayrı raporlanır.

P0 için feature prefixleri senaryo gruplarını gösterir. Geliştirme backlog’unda her test ilgili tam feature ID’lerine bağlanır; P0 gereksiniminden test/kanıt kaydına kadar izlenebilirlik sağlanır.

## 19. Ürün kalitesi, operasyon göstergeleri ve değerlendirme

**v6 yönetim boyutu:** Tekil kayıt/aktif kullanıcı tanımı, üyelik kaynak/durum dağılımı, para birimine göre doğrulanmış tahsilat/iade, unmatched/reconciliation gecikmesi, gecikmiş CRM görevleri, destek ilk yanıt/kapanış ve izin dışı erişim sayılır. Finans rakamı ≠ muhasebe geliri/kârı; ödeme ve sağlık tabloları pazarlama analizi için birleştirilmez. Sağlık ya da mesaj içeriği loglanmadan iş kimliği/durum sayımları kullanılır. Yanıt SLA’sı işletme kararıdır, belge otomatik süre taahhüdü üretmez.

**iOS kalite boyutu:** OS kolu ve cihaz sınıfına göre crash/hang, açılış/katalog/plan editörü gecikmesi, bellek/enerji, eşitleme bekleme nedeni, auth callback ve migration sonucu izlenir. Sağlık verileri, API anahtarları veya hassas kullanıcı ayrıntıları ölçüm loglarına konmaz. Metrik eksikliği o OS kolunun başarısı sayılmaz; alt iPhone 12/mini kanıtı ayrı görünür.

Buradaki ölçütler yazılım/ürün kalitesine ilişkindir; kullanıcıdan fizyolojik ölçüm toplanması anlamına gelmez.

Ürün göstergeleri: haftalık taslağın uygulanabilirliği, önemli kısıt ihlalleri, antrenörün düzeltme nedenleri, plan değişikliği sıklığı, gerçekleşen kayıtlarla doğru eşleşme, kullanıcı geri bildirim yükü, veri güncelliği ve ana akışın tamamlanması.

AI göstergeleri: görev bazlı şema başarı oranı, semantik/politika hatası, kaynak referansı doğruluğu, timeout/ret, bütçe aşımı, model başına gerçek latency ve maliyet belirsizliği. Ortalama gecikmeyle birlikte kuyruk gecikmesi ve kuyruk sonu yüzdelikleri ölçülür.

Operasyon göstergeleri: sync gecikmesi, iş yeniden denemeleri, stuck job, yetkisiz erişim denemesi, duplicate aktivite, stale öneri oranı, export/silme süreci ve bildirim tekrarları. Ham sağlık verisi loglamak bir ölçüm yöntemi değildir.

Model değerlendirmesi yalnızca başka bir LLM’in puanına bırakılmaz. Deterministik testler, uzman incelemesi ve temsili senaryolar birlikte kullanılır. Farklı modellerin aynı metni üretmesi beklenmez; önemli kısıtları ve kalite sınırlarını karşılaması beklenir.

Kontrollü pilotta AI önce öneri üretip antrenör incelemesine sunabilir. Pilot memnuniyeti veya antrenör kabulü tek başına sportif etkinlik ve sakatlık önleme kanıtı değildir. Antrenman etkinliği iddiası yapılacaksa ayrı ve uygun araştırma tasarımı gerekir.

Entegrasyon değerlendirmesinde marka sayısı değil; veri türü başına gerçek kapsama, doğru köken, eşitleme gecikmesinin bilinen kısmı, veri yokluğunun doğru ele alınması ve plan-gerçekleşen eşleşmesi izlenir. Başarılı API cevabı, bütün sağlık verisinin eksiksiz olduğu anlamına gelmez.

Auth/izin göstergeleri: yöntem bazında başarılı giriş/kullanıcı iptali/teknik hata; doğrulama-kurtarma başarısı, hesap çakışması, token replay ve session revoke gecikmesi; izin reddinde başarılı devam, kategori bazlı gözlenen kapsam, izinsiz upload/send denemesi, iptal sonrası engellenen işler ve hesap silme sonucu. İzin kabul oranını artırmak adına yanıltıcı akış tasarlanmaz. Analytics’e e-posta, provider subject, token, antrenör notu veya ham sağlık verisi yazılmaz.

**Branş/katalog kalite göstergeleri:** Kaynak sürümü başına sport/sub_sport/exercise-category/exercise-name sayıları; menu alias kapsamı; eşlemesi belirsiz kayıt; çeviri, kas/ekipman ve rights/review eksikleri; onaylı otomatik reçete adayları; disiplin başına tipli plan ve adaptasyon testleri ayrı raporlanır. Sözlükteki tüm değerleri tek toplamla “spor sayısı” diye sunma. Yalnızca az sayıdaki koşu senaryosunda yüksek başarı tüm sporlara genellenmez. Kullanıcı kabulü teknik/medikal etkinlik kanıtı değildir.

## 20. Tamamlanma tanımı ve teslimatlar

Bir özellik ancak şu koşullarla tamamlanmış sayılır: çalışan kullanıcı akışı, sunucu tarafı yetki/doğrulama, gerekli migration, testler, hata/boş/çevrimdışı durumları, veri kaynaklarının hak kontrolü, telemetri ve kullanım dokümantasyonu.

Kodlama LLM’i şu teslimatları sağlamalıdır:

- Mevcut durum ve fark analizi; gerekçeli mimari kararlar; gereksinim/backlog/test eşleme tablosu.
- Çalışan kaynak kodu, kurulum README’si, gizli bilgi içermeyen örnek yapılandırma, migration ve sentetik seed verisi.
- API sözleşmeleri, veri modeli, plan/öneri/AI şemaları, durum makineleri ve provider contract testleri.
- Fiziksel iPhone üzerinde kaynak uygulama/HealthKit aktarımı ve gerçek AI endpoint test raporu; çalıştırılan komutlar, sonuçlar ve doğrulanamayan noktaların açık listesi.
- Gizlilik/veri akışı, antrenör yetkileri, kaynak kullanım matrisi, model/politika versiyonlama ve operasyon runbook’u.
- Salt okunur veri akışı ve ölçüm/sensör/donanım işlevi bulunmadığına dair izin, dependency ve kullanıcı akışı test raporu.
- Gerçek Apple/Google/e-posta native iPhone giriş, P0 admin davetli giriş/MFA/oturum ve yetki testleri (P1 antrenör web açılınca onun karşılığı), callback güvenliği, relay gönderici, kurtarma, kimlik bağlama ve hesap silme testleri; auth yapılandırma matrisi ve mevcut kullanıcı migration planı.
- İzin metinleri/kategori-alıcı matrisi, HealthKit native izin kanıtı, ret/kısmi/geri çekme ve hesap değişimi testleri; kuyruk ve backend enforcement raporu.
- Yayın kontrol listesi; otomatik yayınlama/AI çağrısı kapatma anahtarı; plan geçmişini koruyan rollback süreci.

- Garmin kaynak sürümü/hash/manifest ve tamlık raporu; kaynak kayıtlar, alias'lar, kanonik içerik, sınıflandırma ve uzman onaylı adayların ayrı sayımı. Lisans kayıtları ve çözülemeyen mapping listesi.
- Kas/bölge/örüntü/ekipman ile Pilates/yoga/yüzme/drill gibi branş filtrelerini içeren çalışan katalog API/UI; tipli blok şemaları, valide edilmiş içerik örnekleri ve kaynak indeksleri.
- HIIT, fonksiyonel, Pilates ve diğer P0 paketlerinin gerçek hafta/adaptasyon testleri; antrenör özel içeriği/erişimi, eski plan snapshot'ı ve v3 → v4 migration/rollback kanıtı.
- `CATALOG_COVERAGE.md`, `SPORT_CAPABILITIES.md`, `CONTENT_REVIEW_POLICY.md`, `CATALOG_MIGRATION.md`, `SOURCE_LICENSES.md`; admin import/review/yayın yönergesi. Katalog adedi ile planlanabilir, uzman onaylı içerik adedi ayrılır.

- Native sporcu/antrenör ekran/akış eşlemesi; iPhone 12 ve sonrası cihaz/OS matrisi; `IOS-SUPPORT-001` açık karar veya çözüm/onay kaydı. iOS 14 için destek verilmediği/kanıtlanmadığı durumda bunu gizlemeyen yayın kapsamı.
- `IOS_SUPPORT_MATRIX.md`, `IOS_DEPENDENCIES.md`, `IOS_TEST_PLAN.md`, `IOS_RELEASE_CHECKLIST.md`; Xcode/SDK/runtime/lockfile kaydı, gerçek cihaz/dağıtım arşivi testleri ve iPhone 12/mini performans raporu. Sadece simulator veya sentetik test yeterli değildir.
- Core Data/SQLite/cache/outbox migration, OS API fallback, kaynak uygulama minimum OS, HealthKit izin/batch/bildirim ve eski istemci API uyumluluğu kanıtları; model/API bağımsız iPhone AI akışları.

- Çalışan web admin kaynak kodu/kurulum/deploy yönergesi; DB tabanlı role/permission başlangıç şablonları, güvenli ilk OWNER/davet, MFA/kurtarma/oturum iptali ve gerçek browser E2E raporu.
- Kayıtlı kullanıcı/CRM tekillik backfill’i, not/etiket/görev/destek ve kullanıcıya açık yanıt; dar alan API’leri, export/retention ve silme sonrası eski event testleri.
- Paket/fiyat/üyelik/grant ve işlem/finans veri modeli; BILLING-001 kararı, kanal capabilities ve source→membership/entitlement durum eşlemesi; fiyat/kota sürümleri, örnekler sentetik ve açık etiketli.
- Ücretli mod seçilmişse gerçek provider sandbox satın alma/restore/iptal/iade/duplicate/out-of-order/sahiplik kanıtı ve iPhone↔admin mutabakatı; canlı tahsilat açma ve geri dönüş runbook’u. Ücretsiz modda gerçek kullanıcı/admin akışı ve kapalı satış kanalı kanıtı, yapılmayan ödeme testleri açık.
- `ADMIN_RBAC_MATRIX`, `ADMIN_SCREEN_CONTRACTS`, `MEMBERSHIP_ENTITLEMENTS`, `BILLING_CHANNEL_MATRIX`, `BILLING_STATE_MAPPING`, `BILLING_RUNBOOK`, `CRM_DATA_RETENTION`, `METRICS_DEFINITIONS` ve v5→v6 migration/rollback açıklaması; bunlar birleştirilmiş dokümanlar da olabilir.

“Tasarlandı”, “mock ile çalıştı”, “gerçek API’de doğrulandı”, “pilot kullanıma hazır” ve “üretimde” ayrı durumlardır. Kod yazılmış olması App Store onayı, bilimsel doğrulama veya üretici veri erişim hakkı anlamına gelmez.

## 21. Kapsam dışında kalanlar

**Her fazda kapsam dışı:** Fizyolojik ölçüm; doğrudan cihaz/sensör/ekipman bağlantısı; giyilebilir uygulaması; antrenman kayıt başlatma/duraklatma; GPS rota kaydı; canlı nabız/tekrar/kalori ölçümü; saate antrenman gönderme; kaynak uygulamanın özel veritabanını veya ekranını kazıma; kaynak sağlık deposuna yazma/silme.

**İlk sürüm dışında:** Ayrı Android/Health Connect istemcisi, antrenör web ürünü, optimize iPad/Mac istemcisi (antrenörün P0 işlevleri iPhone’da korunur); Passkey gibi ek giriş yöntemleri ve iki dolu hesabın otomatik birleşmesi; branş politikası/uzman incelemesi tamamlanmamış ileri teknik AI koçluğu; kapsamı doğrulanmamış bütün sağlık uygulamaları; kesin sakatlık riski; otomatik teşhis/rehabilitasyon; eksik kayıttan eksiksiz beslenme çıkarımı; kullanıcı verisiyle varsayılan model eğitimi; topluluk/pazar yeri; komisyona göre antrenman seçimi; kanıtlanmamış mimari karmaşıklık. Tam satış fırsatı/pipeline/teklif, toplu e-posta-SMS/WhatsApp kampanyası, inbox senkronu, çağrı merkezi, otomatik lead scoring, tam muhasebe/e-fatura motoru, kart kasası, antrenör komisyon/payout ve personelin kullanıcı adına oturum açması P0 değildir. **Özel web admin, kayıtlı kullanıcı/üyelik/ücret takibi ve minimum CRM bu dışlamaya girmez; P0’dır.**

**Kapsam açıklığı:** Geniş spor kataloğu, kategorili içerik, HIIT/fonksiyonel/Pilates ve Bölüm 11.10 P0 paketleri ilk sürüm kapsamındadır. Diğer branşlar “bütün spor dalları sonra” ifadesiyle dışlanmaz; katalog/manuel plan ile doğrulanmış teknik otomasyon farklı seviyelerdir. Garmin kaynak isimlerini kullanma kararı, Garmin cihaz bağlantısı, medya kopyalama veya tam Connect verisine erişim kararı değildir.

Kendi LLM servisini bağlamak, yeni temel model eğitimi gerektirmez. Mevcut servis + kullanıcı BYOK güvenli ve gerçek görevlerde çalışan entegrasyon olarak uygulanır. Android’e genişleme gerekiyorsa ayrı ürün onayı gerekir; iOS projesinin fark ettirmeden büyütülmesi kabul edilmez.

## 22. Kodlama LLM’ine başlangıç talimatı

**Önce platform kararını uygula:** İlk yayın native iOS/iPhone; iPhone 12 ailesi ve sonrası hedeflenir. Sporcu ve antrenör P0 akışları aynı uygulamadadır; ayrı antrenör/tüketici web veya Android projesini ilk teslimin şartı yapma. **Ürün sahibinin tarayıcıdan yöneteceği özel web admin, üyelik/ücret takibi ve minimum CRM ise P0’da ayrıca teslim edilmelidir.** Bölüm 1.6’daki geniş OS talebini, iOS 14 açık araç zinciri farkını ve 15.0 mühendislik önerisini ayrı tut. Minimumu kolaylık için iOS 17/18/26 yapma; yeni SDK ile eski OS desteğini karıştırma. `IOS-SUPPORT-001` çözüm/karar kaydını ve cihaz/OS/bağımlılık/test matrisini oluştur; kanıtlanmamış sürüme destek var deme. Bu belge uygulama geliştirilmiş veya gerçek cihazda test edilmiş değildir.

Bu belgenin bütününü oku. **Sportapp bir ölçüm, saat veya workout recording uygulaması değildir.** Mevcut sağlık uygulamalarının sunduğu izinli kayıtları okuyan; haftalık program ve günlük adaptasyon üreten dijital antrenör/karar desteğidir. Bu ayrımı bütün mimari, ekran, veri modeli, izin ve test kararlarına uygula.

**Hedef kitleyi koşu/kuvvet/HYROX ile daraltma.** Bunlar örnektir. HIIT, fonksiyonel, Pilates ve diğer sporları kategorili kanonik model, branşa özgü deneyim ve tipli seanslarla işle. Kuvvette kas/bölge/örüntü/ekipman; diğer sporlarda uygun drill/poz/stil/aparat/seviye filtrelerini uygula. Yarış hedefi olmayan tek branş kullanıcısı da ana kullanıcıdır.

Önce mevcut repoyu incele. Belgedeki önerileri otomatik olarak mevcut koddan üstün veya uygulanmış kabul etme. Var olan/eksik/yanlış gereksinimleri, korunacak bileşenleri ve sensör/kayıt kapsamıyla çelişen parçaları raporla. Mevcut sistem yoksa gerekçeli referans başlangıç oluştur.

İlk teslimatta D0 çıktılarıyla şu konuları göster: e-posta/Apple/Google kimlik akışı, native iPhone sporcu/antrenör hesap sürekliliği, P0 admin web MFA/DB yetki ve kullanıcı/CRM sözleşmesi, P1 antrenör web için korunmuş kimlik sözleşmesi, auth migration ve izin matrisi; haftalık plan + adaptasyon döngüsü; kaynak uygulama/erişim yolu matrisi; Google Health ile Health Connect ayrımı; Samsung iOS sınırlılığı; sağlık izni ile AI izni ayrımı; platform LLM’i + gerçek BYOK; ilk uçtan uca dilim ve bağımlılıklı backlog.

Apple Health verisini salt okunur HealthKit üzerinden al. Google/Huawei’nin Apple Health’e gerçekten yazdığı veriyi aynı okuyucudan al; tam veri aktarımı varsayma. Resmî uygulama hesap API’sini cihaz SDK’sıyla karıştırma. Health Connect’i iOS veya genel bulut API’si gibi kullanma. Desteklenmeyen yol için endpoint, scope veya başarılı bağlantı ekranı uydurma.

Garmin'i cihaz entegrasyonu değil, sürümlü kaynak sözlüğü referansı olarak kullan. Resmî FIT profilindeki tüm sport/sub_sport/exercise_category ve exercise-name tablolarını staging'e aktar; 20 örnek hareketi tam katalog diye sunma. Model menülerini ve Sportapp ek kategorilerini ayrı kaynaklarla eşle. Ham adları uzman onaylı egzersiz talimatı veya kas grubu haritası sayma; doğrulanmamış açıklama/medyayı yayınlama. Bölüm 11 ve 17.4'teki tamlık, lisans, branş yeteneği ve geçmiş plan koruma kurallarını uygula. Mevcut dış uygulama yalnızca seans özeti paylaşıyorsa hareket/set/tekrar üretip yapılmış gibi saklama.

Geliştirmeyi test edilebilir adımlarla yap. Her adımda değişen dosyaları, migration etkisini, komut/test sonuçlarını ve tamamlanan kullanıcı akışını belirt. Resmî erişim veya uzman incelemesi gerektiren engelleri açık kaydet; mock başarıyı gerçek doğrulama sayma. Engellenmemiş işleri sürdür.

Haftalık plan, BYOK ve antrenör onayı gerçek işlevler olmalı. LLM taslağını doğrudan aktif plana yazma. Sağlık verisini seçilen modele göndermeden önce amaç/alıcı/kaynak izinlerini kontrol et. Kullanıcı beyanını ölçülmüş veri, önerilen nabzı canlı nabız veya son sorgu zamanını ölçüm zamanı gibi sunma.

E-posta/Apple/Google kayıt ve girişini yalnızca düğme olarak ekleme. Sunucuda doğrulama, güvenli hesap bağlama, oturum/kurtarma, provider iptali ve uygulama içi silmeyi tamamla. Login kimliği ile sağlık uygulaması erişimini tek token veya tek onay yapma. Google ile giriş yapmak Google Health izni değildir; Apple ile giriş HealthKit izni değildir.

Sağlık verisi okumak için kategori/amaç/backend aktarım onayı ve gerçek OS/sağlayıcı iznini gerektiği anda al. HealthKit request başarısını tüm read izinlerinin verildiği şeklinde yorumlama. İzin atlama/kısmi/geri çekme ve aynı iPhone’da hesap değiştirme akışlarını gerçek veri korumasıyla uygula; UI’da kutu kapatmak tek başına yeterli değildir. P1 hesap API’sini izin ekranı ekleyerek P0’da bitmiş gösterme.

**Web admin ve ticari yönetim:** 9.1–9.10 ve ilgili API/ekran/testleri uygula. Üyelik, ödeme, erişim hakkı, rol ve sağlık/AI onayını ayrı tut. İlk kayıtların CRM’ye tekil düşmesini; not/etiket/takip/destek işlemlerini; süreli/ücretsiz/ücretli paket görünümünü ve gerçek sağlayıcı olaylarına dayanan ücret takibini teslim et. Admin personeline otomatik sağlık/koç notu/BYOK anahtarı erişimi verme. RBAC’ı yalnız client’ta veya e-posta kodunda tutma.

BILLING-001 kararını, seçilen kanalın mağaza ve sağlayıcı koşullarını, sıfır olmayan gerçek ücret ve satıcı bilgilerini uydurma. Abonelik zorunlu varsayma; üyenin ödeme durumunu manuel boolean ile veya client’tan gelen tutarla yönetme. Ücretli satış açılacaksa doğrulanmış provider transaction/webhook/restore/iptal/iade/mutabakat ve hesap sahipliği testlerini tamamla. Admin web paneli App Store ödeme kurallarını aşma gerekçesi değildir. Minimum CRM talebini tam Salesforce/muhasebe/marketing projesine dönüştürme.

Eski 194 feature ID ve 180 kabul senaryosunu koru; yeni 36 özellik/40 senaryoyu traceability’ye ekle. v5’ten kalan web erteleme ifadelerini yalnız antrenör/tüketici web’ine uygula; P0 admin panelini erteleme. Belge/sentetik test başarısını gerçek iOS, admin frontend, backend veya ödeme sağlayıcısı testi sayma.

Donanım entegrasyonu, kayıt timer’ı, sensör, watch uygulaması veya saate gönderim işi açma. Bu işlevleri “sonraki faz” notuyla geri ekleme. Ürün sahibinin ileride ayrı açık kapsam değişikliği olmadan bu sınırlar geçerlidir.

## 23. Resmî kaynaklar ve doğrulama sınırları

**Kaynak tarihleri:** v4’ten korunan [S1]–[S45] kayıtları önceki belgedeki 15 Eylül 2026 kontrol notunu taşır; bu sürümde hepsi yeniden doğrulanmış sayılmaz. iOS uyumluluğu için [S46]–[S53] v5’te 25 Eylül 2026 kontrol kaydını taşır; bu v6 güncellemesinde iOS kaynakları yeniden test/doğrulama konusu yapılmamıştır. v6 için [S1] ödeme maddeleri ve yeni [S54]–[S57] 25 Eylül 2026’da incelendi; yalnız belirtilen maddeler için güncel inceleme sayılır. Aşağıdaki kaynaklar dış platformların belgelenen davranışlarını destekler. Gereksinimler, öncelikler, şema ve kabul testleri ürün tasarımı önerileridir; üretici garantisi veya yapılmış entegrasyon testi değildir. Geliştirme/yayın sırasında güncel belgeler ve koşullar yeniden kontrol edilmelidir.

**[S1] Apple — App Review Guidelines.** Özellikle kişisel verinin üçüncü taraf AI ile paylaşımı, sağlık verisi ve doğru ürün iddiaları.  
`https://developer.apple.com/app-store/review/guidelines/`

**[S2] Apple — HKAuthorizationStatus.** HealthKit okuma izninin mahremiyet nedeniyle doğrudan anlaşılamadığı durumlar; okuma ve yazma durumunu karıştırmama.  
`https://developer.apple.com/documentation/healthkit/hkauthorizationstatus`

**[S3] Apple — Executing Observer Queries / HKObserverQuery.** Veri değişikliği sonrası sorgulama, arka plan çalışma ve fiziksel iPhone testi.  
`https://developer.apple.com/documentation/healthkit/executing-observer-queries`  
`https://developer.apple.com/documentation/healthkit/hkobserverquery`

**[S4] Apple — HealthKit / Health and fitness apps.** Ortak sağlık veri deposundan izinli okuma; Motion/Location ölçüm kabiliyetlerinden ayrım.  
`https://developer.apple.com/documentation/healthkit`  
`https://developer.apple.com/health-fitness/`

**[S5] Ollama — OpenAI compatibility.** Uyumlu API yüzeyi ve yetenek farklılıkları.  
`https://docs.ollama.com/api/openai-compatibility`

**[S6] vLLM — Online Serving.** API ve model yeteneklerini gerçek endpoint’te doğrulama gereksinimi.  
`https://docs.vllm.ai/en/latest/serving/online_serving/`

**[S7] OpenAI — Structured model outputs.** JSON schema/structured output mekanizmaları; antrenman doğruluğunun yerine geçmez.  
`https://developers.openai.com/api/docs/guides/structured-outputs`

**[S8] Apple — App Privacy Details.** Uygulama dışına aktarılan/saklanan veri ve üçüncü tarafların beyanı.  
`https://developer.apple.com/app-store/app-privacy-details/`

**[S9] Strava — API Policy.** API üzerinden elde edilen veri için AI/context ve türetilmiş veri kullanım koşulları.  
`https://www.strava.com/legal/api_policy`

**[S10] OWASP — Server Side Request Forgery Prevention Cheat Sheet.** Özel AI endpoint’lerinde URL/ağ/DNS/redirect kontrolleri.  
`https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html`

**[S11] OWASP — Secrets Management Cheat Sheet.** API anahtarı/OAuth sırlarının yaşam döngüsü ve korunması.  
`https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html`

**[S12] Google — How do I use Apple Health with the Google Health app?** İki yönde paylaşım, kurulum ve veri türü bazlı okuma/yazma tablosu.  
`https://support.google.com/googlehealth/answer/17037331?hl=en`

**[S13] Google — Google Health API.** Google Health/Fitbit veri hesabına yönelik resmî API; Health Connect ile aynı ürün değildir.  
`https://developers.google.com/health`  
`https://developers.google.com/health/reference/rest`

**[S14] Samsung — Samsung Health Data SDK.** Samsung Health uygulamasındaki verilere erişim; Android gereksinimleri.  
`https://developer.samsung.com/health/data/overview.html`

**[S15] Samsung — Accessing Samsung Health Data through Health Connect.** Android üzerinde uygulama paylaşımı ve eşitleme akışı.  
`https://developer.samsung.com/health/blog/en/accessing-samsung-health-data-through-health-connect`

**[S16] Google — Check Health Connect availability.** Android/Google Play ve yerel veri deposu sınırı.  
`https://developer.android.com/health-and-fitness/health-connect/availability`

**[S17] Huawei — HUAWEI Health: Europe, geliştiricinin App Store açıklaması.** Egzersiz verilerinin HealthKit ile paylaşımı; kategori/bölge/sürüm testinin yerine geçmez.  
`https://apps.apple.com/gb/app/huawei-health-europe/id6474852610`

**[S18] Huawei — Open Data Overview / API Usage.** Health Kit bulut/REST yolu. Sayfaların dinamik içerik erişimi bu araştırmada sınırlıydı; endpoint kapsamı ve proje onayı doğrulanmış değildir.  
`https://developer.huawei.com/consumer/en/doc/HMSCore-Guides/data_description-0000001467889369`  
`https://developer.huawei.com/consumer/en/doc/HMSCore-References/rest-overview-0000001254420693`

**[S19] Samsung — Samsung Health, geliştiricinin iOS App Store açıklaması.** Apple Health adım verisinin Samsung Health’e aktarılması; ters yönde tam veri ihracı kanıtı değildir.  
`https://apps.apple.com/us/app/samsung-health/id1224541484`

**[S20] Apple — Security of runtime process in iOS, iPadOS, and visionOS.** Uygulama sandbox’ı ve diğer uygulama verilerine resmî servislerle erişim sınırı.  
`https://support.apple.com/guide/security/security-of-runtime-process-sec15bfe098e/web`

**[S21] Google — Google Health API Developer and User Data Policy.** Hesap API’si kullanım, paylaşım ve veri işleme koşulları.  
`https://developers.google.com/health/policies/health-api-developer-user-data-policy`

**[S22] Google — Fit migration guide.** Yeni entegrasyonlarda Health Connect/Google Health API ayrımı.  
`https://developer.android.com/health-and-fitness/health-connect/migration/fit`

**[S23] Apple — Get the most out of Sign in with Apple (WWDC20).** Native nonce/state, ilk yetkilendirme profil alanları, credential durumları ve signed server bildirimleri.  
`https://developer.apple.com/videos/play/wwdc2020/10173/`

**[S24] Google — Integrating Google Sign-In into your iOS or macOS app.** Resmî SDK, redirect, giriş/çıkış ve entegrasyon akışı.  
`https://developers.google.com/identity/sign-in/ios/sign-in`

**[S25] Google — Authenticate with a backend server.** ID token’ı backend’de doğrulama ve istemciden gelen düz user ID’ye güvenmeme.  
`https://developers.google.com/identity/sign-in/ios/backend-auth`

**[S26] Google — OpenID Connect.** Issuer/audience/süre/imza doğrulaması, subject ve token semantiği.  
`https://developers.google.com/identity/openid-connect/openid-connect`

**[S27] Apple — Offering account deletion in your app.** Uygulama içi hesap silme ve Sign in with Apple token iptali.  
`https://developer.apple.com/support/offering-account-deletion-in-your-app/`

**[S28] Apple — Configure private email relay service.** Gönderici alanları ve private relay e-posta yapılandırması.  
`https://developer.apple.com/help/account/capabilities/configure-private-email-relay-service/`

**[S29] OWASP — Authentication Cheat Sheet.** Parola politikası, generic hata, oran sınırlama ve yeniden doğrulama.  
`https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html`

**[S30] OWASP — Password Storage Cheat Sheet.** Parola hash saklama ve güvenli algoritma/maliyet yönetimi.  
`https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html`

**[S31] OWASP — Forgot Password Cheat Sheet.** Süreli tek kullanımlık kurtarma token’ları ve sıfırlama güvenliği.  
`https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html`

**[S32] OWASP — Session Management Cheat Sheet.** Oturum saklama, yaşam döngüsü, cookie güvenliği ve iptal.  
`https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html`

**[S33] IETF — RFC 8252: OAuth 2.0 for Native Apps.** Native uygulamalarda harici yetkilendirme aracısı, public client ve PKCE yaklaşımı.  
`https://www.rfc-editor.org/info/rfc8252/`

**[S34] Apple — Authorizing access to health data.** HealthKit amaç açıklaması, veri türü bazlı OS izni ve read yetkisinin gözlenebilirlik sınırı.  
`https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data`

**[S35] Apple — requestAuthorization(toShare:read:completion:).** HealthKit izin talebi; işlemin tamamlanması ile read kapsamını ayırma.  
`https://developer.apple.com/documentation/healthkit/hkhealthstore/requestauthorization(toshare:read:completion:)`

**[S36] Google — Using OAuth 2.0 for Web Server Applications.** API erişimi, incremental authorization, scopes, access/refresh token, state ve revoke.  
`https://developers.google.com/identity/protocols/oauth2/web-server`

**[S37] Garmin — FIT Python SDK 21.214.0 sürüm kaydı.** 25 Ağustos 2026 tarihli, bu dokümanda sabitlenmiş referans; sürüm bilgisi GitHub ve paket kaydından kontrol edildi. "Bütün Garmin ürünleri" anlamına gelmez.  
`https://github.com/garmin/fit-python-sdk/releases/tag/21.214.0`  
`https://pypi.org/project/garmin-fit-sdk/21.214.0/`

**[S38] Garmin — FIT Profile, 21.214.0.** Resmî kaynak sözlükleri `sport`, `sub_sport`, `exercise_category`, `*_exercise_name`; kategori ve hareket kodları ayrı, yorumlarda deprecated değerler bulunur. Dosya başlığı FIT Protocol License belirtir. Git blob SHA: `e069ce43ae3501d5dc197e4db784534e8d9394c1`.  
`https://github.com/garmin/fit-python-sdk/blob/21.214.0/garmin_fit_sdk/profile.py`

**[S39] Garmin — fēnix 8 Series, Activities.** Haziran 2026 v8 kılavuzunun kategorili aktivite listesi; bir aktivite birden çok menü kategorisinde olabilir.  
`https://www8.garmin.com/manuals/webhelp/GUID-EECCAC99-90D6-4AB1-9A3A-EC433D3365E2/EN-US/GUID-00B74ABF-7DB4-4DC2-9CA5-9D2F12B65A10.html`

**[S40] Garmin — Instinct 3 AMOLED, Activities.** Mayıs 2026 v5; model/edition bazlı liste ve yalnızca bazı modellerde olan profiller.  
`https://www8.garmin.com/manuals/webhelp/GUID-2DA54DF8-8084-40ED-954F-EDA09C13B47F/EN-US/GUID-514A2FF7-B873-4AEE-9DE8-5993E7007087.html`

**[S41] Garmin — vívoactive 6, Activities.** Haziran 2026 v6; Handcycle ve Handcycle Indoor gibi farklı aktivite varyantları.  
`https://www8.garmin.com/manuals/webhelp/GUID-8C2C402F-55AC-431F-9CF2-1442B89CE149/EN-US/GUID-4906F77A-0B26-48F9-A4DB-72752E06532D.html`

**[S42] Garmin — fēnix 9, Activities.** Ağustos 2026 v1; güncel başka bir modelin kategori/aktivite listesi. Listeler model ve sürümle saklanmalı.  
`https://www8.garmin.com/manuals/webhelp/GUID-708A8F4D-9A78-49CF-9528-DE109BBCC472/EN-US/GUID-D57766B8-2585-4E00-B1BE-6954B4C8145C.html`

**[S43] Garmin — Pre-Made Workouts from Garmin Connect.** Koşu dışı strength/cardio/yoga/Pilates gibi içerik ve workout açıklaması; hareket kodundan ayrı içerik/animasyon katmanı bulunduğunu gösterir.  
`https://www.garmin.com/en-US/blog/general/pre-made-workouts-from-garmin-connect/`

**[S44] Garmin — Making the Most of HIIT Workouts with Garmin.** HIIT bağlamında EMOM/AMRAP/Tabata gibi biçimler. Bu belge söz konusu formatları Sportapp içinde yalnızca planlanan tipli bloklar olarak kullanır; kronometre/kayıt yok.  
`https://www.garmin.com/en-US/blog/fitness/making-the-most-of-hiit-workouts-with-garmin/`

**[S45] Garmin — FIT SDK ve lisans çerçevesi.** Resmî SDK ve kaynak dosyanın FIT Protocol License bildirimi esas alınır; sözlük kullanımı, SDK yeniden dağıtımı, marka ve medya hakları ayrı değerlendirilir. Bu doküman bir kullanım izni veya hukuk görüşü değildir.  
`https://developer.garmin.com/fit/get-the-sdk/`  
`https://developer.garmin.com/ant-program/licensing/`

**[S46] Apple — Xcode SDKs and system requirements.** Kontrol edilen Xcode 26/27 deployment, device support ve simulator sütunları; birbirlerinin yerine geçmez. Sürüm tablosu canlıdır, release öncesi tekrar kontrol edilir.
`https://developer.apple.com/xcode/system-requirements`

**[S47] Apple — Upcoming Requirements.** Kontrol anında 28 Nisan 2026 Xcode/SDK şartı ve 9 Eylül 2026 minimum sistem hedefi ayrı açıklanıyor. Deployment toolchain desteğiyle aynı kavram değildir.
`https://developer.apple.com/news/upcoming-requirements/`

**[S48] Apple — iPhone 12 / 12 mini tanıtımı, 13 Ekim 2020.** iPhone 12 ailesinin tarihsel iOS 14 dönemi; eski OS’nin bugün destekli build/test/mağaza yolunu kanıtlamaz.
`https://www.apple.com/newsroom/2020/10/apple-announces-iphone-12-and-iphone-12-mini-a-new-era-for-iphone-with-5g/`

**[S49] Apple — iPhone models compatible with iOS 27.** Kontrol edilen uyumluluk listesinde iPhone 12 ailesi bulunuyor. Gelecek sürüm veya Sportapp test kanıtı değildir.
`https://support.apple.com/en-nz/guide/iphone/iphe3fa5df43/ios`

**[S50] Apple — Required Device Capabilities.** App Store’un gerçek donanım yeteneklerini kullanarak uyumluluk değerlendirmesi; pazarlama modeli adına göre uydurma filtre kullanmama.
`https://developer.apple.com/support/required-device-capabilities/`
`https://developer.apple.com/documentation/bundleresources/information-property-list/uirequireddevicecapabilities`

**[S51] Google — Google Sign-In iOS/macOS SDK Release Notes.** İncelenen 10.0.0 notunda iOS 15.0 tabanı ve eski OS gereksinimi için 9.2.0 ayrımı; geçişli dependency etkisi. Entegrasyon için [S24] de geçerlidir.
`https://developers.google.com/identity/sign-in/ios/release`

**[S52] Apple — Migrate to SwiftData, WWDC23.** SwiftData’nın iOS 17 ile kullanılabilirliği ve eski Core Data uygulamasıyla geçiş/beraber kullanım değerlendirmesi. Bu belgede eski OS için tek uyumlu repository önerilir.
`https://developer.apple.com/videos/play/wwdc2023/10189/`

**[S53] Apple Platform Security — Protecting access to user’s health data.** Sağlık deposunun korunması ve kilit koşullarında erişim sınırları. Sportapp bu sınırları workout recording oturumu açarak aşmaz; yalnızca mevcut kayıt okuyucusudur.
`https://support.apple.com/guide/security/protecting-access-to-users-health-data-sec88be9900f/web`

**[S54] Apple — StoreKit 2.** İmzalı transaction, product/entitlement, geri yüklenebilen güncel işlem, kullanıcı refund/manage ve test yüzeyi. API’nin bulunması uygulama test kanıtı değildir. 25 Eylül 2026.  
`https://developer.apple.com/storekit/`

**[S55] Apple — App Store Server Node.js Library (resmî depo).** Server API, bildirim imzası doğrulaması, ortam/bundle/app kimliği ve transaction history örnekleri. Sürüm/runtime D0’da destek politikasına göre seçilir; örnek README minimumu production sürümü önerisi değildir. 25 Eylül 2026.  
`https://github.com/apple/app-store-server-library-node`

**[S56] OWASP — Authorization Cheat Sheet.** En az yetki, varsayılan ret, her istekte nesne/eylem yetkilendirmesi. DB rol/izin modelinin somut tasarımı Sportapp gereksinimidir. 25 Eylül 2026.  
`https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html`

**[S57] OWASP — Cross-Site Request Forgery Prevention Cheat Sheet.** Cookie tabanlı web mutasyonlarında mevcut framework koruması, token ve origin yaklaşımı; SameSite tek başına bütün güvenlik kontrollerinin yerine geçmez. 25 Eylül 2026.  
`https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html`

### Doğrulama notu

**v6 teslim sınırı:** Bu sürüm mevcut v5 gereksinim dosyasını düzenler; web admin/frontend/backend/iOS uygulaması veya ödeme entegrasyonu geliştirilmiş değildir. Yapılan dosya-kimlik/yapı ve yardımcı importer kontrolleri paket raporunda, gerçek uygulama/sağlayıcı testleri `NOT_RUN` olarak yer alır. Ticari fiyat/kanal seçimi ve ilgili gerçek hesap testleri açık geliştirme adımlarıdır. Önceki kaynak, katalog, sensörsüz veri ve iOS uyumluluk sınırları değişmez.

**v5’ten korunan tarihsel teslim notu:** Önceki v5 güncellemesinde iOS cihaz/OS/araç zinciri ve ilgili bağımlılık belgeleri kontrol edilip gereksinimler, mimari, akışlar ve testler değiştirildi. Bir Xcode projesi derlenmedi, iPhone/Simulator çalıştırılmadı, TestFlight/App Store’a yükleme yapılmadı. 180 senaryo bir kabul planıdır; 180 testin geçtiği iddiası değildir. iOS 14 uyumluluğu açık, iOS 15.0 tabanı öneridir. Özgün katalog importer’ının sentetik testleri paket oluşturulurken ayrıca çalıştırılır; sonucu `validation_report.json`/test çıktısındadır ve iOS uyumluluğu kanıtı sayılmaz.

Bu belgeyle Sportapp uygulaması geliştirilmiş, hesaplar yapılandırılmış, kaynak uygulamalara bağlanılmış veya ürün veritabanına egzersizler yüklenmiş değildir. v4'te Garmin'in resmî FIT sürümü/sözlük yapısı, örnek hareket kategorileri ve birden fazla resmî model kılavuzunun aktivite kapsamı incelendi. **Garmin Connect'teki bütün güncel ekran hareketlerinin, bütün saat modellerinin ve lisanslı görsel/animasyonların eksiksiz alındığı iddia edilmez.** Pinlenmiş sözlüğün tam import'u ve kapsam/rights/review raporu geliştirme kabul şartıdır; bu dosya hazır ve uzman onaylı bir veritabanı değildir.

Eşlik eden `Sportapp_Garmin_Catalog_Importer_v4.py`, yerelden alınan resmî profile.py içindeki hedef sözlükleri Python AST ile, dosyayı çalıştırmadan JSON staging verisine dönüştüren bağımsız referans yardımcıdır. **v4 bileşeni için 12 sentetik birim/CLI testi vardır; v6 paketinde yeniden çalıştırma sonucu ayrıca raporlanır. Tam resmî kaynak dosyasıyla uçtan uca import bu teslimatta çalıştırılmadı.** Gerçek kaynak sürüm/hash/sayım karşılaştırması, lisans değerlendirmesi, kas/branş metadata incelemesi ve üretim seed'i D3/D9'da ayrıca gereklidir. Garmin SDK/katalog medyası bu teslimatla yeniden dağıtılmaz.

v3'ün auth, izin ve v2'den gelen uygulama kaynak matrisi korunmuştur; bu güncellemede bütün önceki API'lerin yeniden veya gerçek hesapla test edildiği iddia edilmez. Huawei bulut erişiminin ayrıntılı koşulları ve Samsung iOS veri yolu açık geliştirme kapılarıdır. Eksik kaynak erişimi veya içerik incelemesi yanlış tamamlanma beyanı yerine ayrı bağımlılık olarak izlenir.

## 24. Kaynak sözlüğü importer’ını kullanma ve teslim sınırı

Bu yardımcı kod nihai backend mimarisi değildir; protokol sözlüğünden tekrar üretilebilir bir seed hazırlama örneğidir. Kaynak `profile.py` dosyasını resmî, sürümü sabitlenmiş Garmin dağıtımından kullanım şartlarına uygun olarak elde et. Ham Python dosyası import/exec edilmez. Kullanıcı sağlık verisi, cihaz veya canlı bağlantı gerekmez.

```bash
python3 Sportapp_Garmin_Catalog_Importer_v4.py \
  --profile ./profile.py \
  --expected-version 21.214.0 \
  --out ./garmin_source_vocabulary.json
```

Bağımsız doğrulanmış SHA-256 varsa `--expected-sha256 <SHA256>` kullan. Çıktı ham kaynak sözlüğüdür: `sport`, `sub_sport`, `exercise_category` ve bulunan her `*_exercise_name` tablosu; source key/name/code/version/comment, deprecated/marker bilgisi, hash, sayım ve unresolved kategori uyarıları. Kategori kodu 0 olan hareketler de geçerlidir; truthiness ile kaybedilmez. Aynı numeric code farklı tablolarda farklı kimliktir. `sub_sport` ebeveyni veya TR ad/kas/ekipman otomatik tahmin edilmez.

Üretilen her kayıt `SOURCE_ONLY`, `NOT_REVIEWED`, `automatic_prescription_eligible=false` başlangıç durumundadır. Çıktıyı doğrudan canlı planlama kataloğu yapma. Bölüm 11.7, 13.6 ve 17.4'teki mapping, hak/çeviri/uzman inceleme, atomik yayın ve geçmiş sürüm koruma adımlarını tamamla. Girdi/çıktı yolu aynı olamaz; sürüm/hash/bozuk sözlükte hata kodu 2, başarılı yazımda 0 döner. Maksimum girdi boyutu 10 MiB'dır; standart kütüphane dışında paket gerekmez.
