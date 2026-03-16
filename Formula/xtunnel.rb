class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.2.0/xtunnel-v2.2.0-osx-arm64.tar.gz"
      sha256 "31a55eea55093ab37a9786223d9747bc37929483d847c8e1a659fab3537e5dba"
    else
      url "https://dl.xtunnel.ru/v2.2.0/xtunnel-v2.2.0-osx-x64.tar.gz"
      sha256 "06faadccd36e626dc7039129ac01fbd8930be916da853df90cb95592f43439a4"
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