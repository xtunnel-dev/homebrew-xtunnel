class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.4.0/xtunnel-v2.4.0-osx-arm64.tar.gz"
      sha256 "b533a2a135072665b83f1634d609a73e3ecc9e8db40b1746f56c6f6c19be3633"
    else
      url "https://dl.xtunnel.ru/v2.4.0/xtunnel-v2.4.0-osx-x64.tar.gz"
      sha256 "d8d4512c3e9ff0d74bebad1615b09f0ec9056701a61438ccbc7f24f9eb6afc2c"
    end
  end

  def install
    bin.install "xtunnel"
    prefix.install "xtunnel-cert.cer"
  end

  def caveats
    cert_installed = quiet_system("security", "find-certificate", "-c", "xtunnel.dev")

    if cert_installed
      "✅ Сертификат xtunnel.dev уже установлен. Никаких дополнительных действий не требуется."
    else
      <<~EOS
        🔐 Установка сертификата (рекомендуется):
        Чтобы macOS доверяла утилите и не показывала предупреждений при запуске, установите сертификат разработчика.

        Выполните команду:
          sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain #{opt_prefix}/xtunnel-cert.cer
      EOS
    end
  end

  test do
    assert_predicate bin/"xtunnel", :exist?, "xtunnel executable should exist"
  end
end