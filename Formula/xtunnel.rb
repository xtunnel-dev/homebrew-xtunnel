class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "1.0.19"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.19/xtunnel.osx-arm64.1.0.19.zip"
      sha256 "30844c41eddc6397489a9093b9afceaa350454f62f344174a53665941843cdea"
    else
      url "https://github.com/xtunnel-dev/xtunnel-binaries/raw/refs/heads/main/1.0.19/xtunnel.osx-x64.1.0.19.zip"
      sha256 "9c0dfa40481cd20d008b9d8a35813b8f09078a60342dfd1e3676dde9995c0068"
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