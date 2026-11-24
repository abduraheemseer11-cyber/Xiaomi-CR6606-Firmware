# WrtMax Firmware Solutions — Xiaomi CR6606 / AX1800

**Source repository only:** this repository builds firmware through GitHub Actions; it is not a precompiled firmware image.

## English

### Target
- OpenWrt branch: `openwrt-24.10`
- Target: `ramips/mt7621`
- Requested profile: `xiaomi_cr6606`
- Firmware version: `1.0.0`
- Default management address: `192.168.1.20`
- Hostname: `WrtMax`
- Support: `776 538 297`

The workflow checks that the requested profile exists in the selected OpenWrt source tree. If it does not, the build stops with an explicit error rather than silently building for another device. Confirm the CR6606 profile and flash layout against the exact hardware revision before flashing.

### Build
1. Upload this repository to GitHub.
2. Enable Actions and run **Build WrtMax CR6606**.
3. Download the `WrtMax-CR6606-firmware` artifact, inspect the image and verify its checksum.
4. Flash only an image built for the exact CR6606 hardware revision, using a recovery method and a verified backup.

The build uses upstream open-source MediaTek drivers. “MTK Proprietary Optimized” is a UI label only; no closed vendor Wi-Fi blobs are built.

### Local ZIP packaging
Run:
```sh
python3 scripts/make-zip.py
```
This creates `WrtMax-CR6606-Repo.zip` in the current repository directory.

### Important hardware/regulatory notes
- The MT7621AT is not treated as having an internal temperature sensor. The dashboard reads available Wi-Fi-chip hwmon `temp1_input` values.
- Regulatory-domain settings and TX power are constrained by the driver, EEPROM calibration, country rules and local law. A requested 30/32 dBm value is a ceiling/request, not a promise or authorization to transmit at that power. The build does not falsify the regulatory database.
- Hardware flow offload is enabled as a firewall request; actual hardware acceleration depends on the platform driver and packet path.
- Open Wi-Fi defaults are intentionally configured as requested. Change them to WPA2/WPA3 before exposing the router to untrusted users.
- OTA uses HTTPS, manifest validation, SHA-256 and `sysupgrade -T`. Use only a trusted update server and a device-specific image.
- Port changes, network wizard actions, restore operations and loop protection can interrupt connectivity. Keep local recovery access.

## العربية

### الهدف
هذا المستودع يبني إصدار **WrtMax Firmware Solutions** لجهاز Xiaomi CR6606 / AX1800 عبر GitHub Actions. الملف الناتج من هذا المشروع هو مصدر البناء، وليس ملف firmware جاهزاً مسبقاً.

- فرع OpenWrt: `openwrt-24.10`
- المنصة: `ramips/mt7621`
- ملف الجهاز المطلوب: `xiaomi_cr6606`
- الإصدار: `1.0.0`
- عنوان الإدارة الافتراضي: `192.168.1.20`
- اسم الجهاز: `WrtMax`
- الدعم: `776 538 297`

يتحقق مسار البناء من وجود ملف الجهاز في مصدر OpenWrt. إذا لم يكن موجوداً فسيتوقف البناء برسالة واضحة، ولن يتم إنشاء firmware لجهاز مختلف بالخطأ. تحقق من نسخة الجهاز ومخطط الفلاش قبل التفليش.

### طريقة البناء
1. ارفع محتويات المستودع إلى GitHub.
2. فعّل GitHub Actions وشغّل **Build WrtMax CR6606**.
3. نزّل artifact باسم `WrtMax-CR6606-firmware`.
4. افحص ملف الصورة و checksum قبل التفليش.
5. لا تستخدم الصورة إلا على نسخة CR6606 المطابقة تماماً، واحتفظ بنسخة احتياطية وطريقة استعادة.

### إنشاء ZIP محلياً
نفّذ:
```sh
python3 scripts/make-zip.py
```
سيتم إنشاء الملف `WrtMax-CR6606-Repo.zip` داخل مجلد المشروع.

### ملاحظات مهمة
- لا يفترض المشروع وجود حساس حرارة داخلي في MT7621AT؛ تتم قراءة حساس شريحة Wi-Fi من `hwmon` عند توفره.
- لا يمكن تجاوز قوانين الترددات أو قدرة الإرسال. قيم 30/32 dBm هي طلبات إعداد فقط، وقد يرفضها التعريف أو تنظيم البلد أو معايرة الجهاز.
- خيار Hardware Flow Offloading لا يعني بالضرورة أن التسريع العتادي يعمل فعلياً على كل مسار.
- شبكتا Wi-Fi الافتراضيتان مفتوحتان حسب الطلب؛ غيّر التشفير إلى WPA2/WPA3 قبل الاستخدام العام.
- عمليات OTA وتغيير المنافذ واستعادة النسخ الاحتياطية قد تقطع الاتصال. نفّذها مع توفر وصول محلي.

## Package inventory
Fourteen WrtMax packages are included: branding, dashboard, Wi-Fi analyzer, CPU manager, quick setup, client manager, security, OTA, port manager, backup, assistant, speedtest, driver control and loop prevention.
