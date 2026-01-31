class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.0.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.0.2/xtunnel-v2.0.2-osx-arm64.tar.gz"
      sha256 "dec294a133825c3f63a756a1acedcb065d76a5db49ee0015d5e25ed3c9874517"
    else
      url "https://dl.xtunnel.ru/v2.0.2/xtunnel-v2.0.2-osx-x64.tar.gz"
      sha256 "d86be813f667209148f9cdf45a7e41f9a1898fa8dfb85c2a2e55a443b2392c44"
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