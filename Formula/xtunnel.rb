class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.1.0/xtunnel-v2.1.0-osx-arm64.tar.gz"
      sha256 "5f4ebf77fd9e533e021aacc1d87d451b0a23df8f612030a723d2c70e7c8e856d"
    else
      url "https://dl.xtunnel.ru/v2.1.0/xtunnel-v2.1.0-osx-x64.tar.gz"
      sha256 "275a498394e5724173f022aa62fab3bce24d57be3fece622704716139f08a9ab"
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