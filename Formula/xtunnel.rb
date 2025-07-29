class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "1.0.18.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.18/xtunnel.osx-arm64.1.0.18.zip"
      sha256 "5845e353285fd2823bfe5a28af7e281573b252315f703b015cbb504728e42c9b"
    else
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.18/xtunnel.osx-x64.1.0.18.zip"
      sha256 "0a081464550316c7be8ff6a1d7309f0b16c556b02c6e6eeb4c8f8a52173a06ef"
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