class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.3.0/xtunnel-v2.3.0-osx-arm64.tar.gz"
      sha256 "fbaccefacfb71d5388dbd3818d3aee49120382c0454e65d45a0b437eda29be6e"
    else
      url "https://dl.xtunnel.ru/v2.3.0/xtunnel-v2.3.0-osx-x64.tar.gz"
      sha256 "a8c903fe47f7773a39180fb7b6d5507204780b4be32bdcbffedb4e18624d9ecb"
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