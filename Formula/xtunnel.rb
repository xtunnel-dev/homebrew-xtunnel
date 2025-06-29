class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "1.0.17"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.17/xtunnel.osx-arm64.1.0.17.zip"
      sha256 "02b1eef622c83f19d7c72c25fdbdeb6a5014bfa5cecf21e674a3e1b8cca9d101"
    else
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.17/xtunnel.osx-x64.1.0.17.zip"
      sha256 "be855d6a6d192628c6de1889ff1e52c3b8386801d133a5d1e1ae6263e70fdc58"
    end
  end

  def install
    bin.install "xtunnel"

    cert_path = buildpath/"xtunnel-cert.cer"
    if cert_path.exist?
      puts "🔐 Устанавливаем сертификат разработчика..."
      begin
        system "sudo", "security", "add-trusted-cert", "-d", "-r", "trustRoot", "-k", "/Library/Keychains/System.keychain", cert_path
      rescue
        puts <<~EOS

          ⚠️  Не удалось установить сертификат автоматически.
          Установите вручную:

            1. Откройте файл: open "#{cert_path}"
            2. Нажмите “Добавить”, выберите “Система” или “Логин”
            3. Укажите хранилище: “Доверенные корневые центры”

        EOS
      end
    else
      puts "❗ Файл сертификата не найден, установка будет без него."
    end
  end

  test do
    system "#{bin}/xtunnel", "--version"
  end
end