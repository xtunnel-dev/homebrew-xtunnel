class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.0.1/xtunnel-v2.0.1-osx-arm64.tar.gz"
      sha256 "ee2a379ccb2b8f472bbc5c96a2ecbb4d35db425f725df38e7a970b9bddedfa16"
    else
      url "https://dl.xtunnel.ru/v2.0.1/xtunnel-v2.0.1-osx-x64.tar.gz"
      sha256 "46a7e34927a07ddbb5564652ad6d2892c7ebb38562c2e61aa2f5cd7f8424571e"
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