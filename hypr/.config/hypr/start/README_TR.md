# HyprFlow Desktop Entry Script

## Amaç
Bu Bash scripti, Wayland oturum yöneticisi Hyprland'i başlatmak için bir ".desktop" dosyası oluşturarak yeni bir oturum seçeneği ekler. Oluşturulan dosya, sistemdeki oturum seçicilerde "HyprFlow" adıyla görünecektir.

## Çalışma Şekli
Script aşağıdaki adımları gerçekleştirir:

1. **Hedef Dizini Kontrol Eder:**
   - Desktop entry dosyasının oluşturulacağı dizini kontrol eder.
   - Bu dizin genellikle "/usr/share/wayland-sessions" yolunda bulunur.

2. **Yeni Dosyayı Oluşturur:**
   - HyprFlow oturumu için gerekli olan ".desktop" dosyasını oluşturur.
   - Dosyada oturumun adı, açıklaması ve başlatılacak komut tanımlanır.

3. **Dosya İzinlerini Ayarlar:**
   - Oluşturulan dosyaya yalnızca okuma ve yazma yetkisi tanımlanır (644).

4. **Kullanıcıya Geri Bildirim Verir:**
   - İşlem başarılı olursa dosyanın oluşturulduğunu bildirir.
   - Eğer hedef dizin bulunamazsa hata mesajı görüntüler.

## Kullanım
Script halihazırda şu dizinde bulunmaktadır: `~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh`.

1. Scriptin çalıştırılabilir olduğundan emin olun:
   ```bash
   chmod +x ~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh
   ```
2. Scripti root yetkisiyle çalıştırın:
   ```bash
   sudo ~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh
   ```

## Örnek Çıktılar
- Başarılı bir işlem için:
  ```
  Yeni desktop entry başarıyla oluşturuldu: /usr/share/wayland-sessions/hyprflow.desktop
  ```
- Hata durumunda:
  ```
  Hata: Hedef dizin bulunamadı: /usr/share/wayland-sessions
  ```

## Oluşturulan Dosya İçeriği
Script çalıştırıldığında aşağıdaki içerikle bir dosya oluşturur:

```plaintext
[Desktop Entry]
Name=HyprFlow
Comment=Modern Wayland Compositor
Exec=/home/kenan/.config/hypr/start/hyprland.sh
Type=Application
DesktopNames=Hyprland
```

- **Name:** Oturumun adını belirtir.
- **Comment:** Oturum hakkında kısa bir açıklama içerir.
- **Exec:** Hyprland oturumunu başlatmak için kullanılan komutu gösterir.
- **Type:** Uygulama türünü belirtir (Application).
- **DesktopNames:** Oturum yöneticisindeki ismi belirler.

## Gereksinimler
- Scriptin çalıştırılabilmesi için root yetkisi gereklidir.
- `/usr/share/wayland-sessions` dizini mevcut olmalıdır.
- Hyprland kurulumu ve `hyprland.sh` başlatma scriptinin doğru bir şekilde yapılandırılmış olması gerekir.

