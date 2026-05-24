class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.6.0/xtunnel-v2.6.0-osx-arm64.tar.gz"
      sha256 "212f28b3689b16b396e92c460555ebe4a506412f38487e7c1ac72387a7482506"
    else
      url "https://dl.xtunnel.ru/v2.6.0/xtunnel-v2.6.0-osx-x64.tar.gz"
      sha256 "37ce9781329d8150f01828b8dbdb61649e2c7486319b89b5a9698eab368fca53"
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