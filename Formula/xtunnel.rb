class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "1.0.17.1"

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