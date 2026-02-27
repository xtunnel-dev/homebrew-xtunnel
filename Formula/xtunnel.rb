class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.1.1/xtunnel-v2.1.1-osx-arm64.tar.gz"
      sha256 "a19507ae68373bbebd2707b078ec45092a632358a9e1d5991e34e42ae906be9c"
    else
      url "https://dl.xtunnel.ru/v2.1.1/xtunnel-v2.1.1-osx-x64.tar.gz"
      sha256 "9b6d5a7391a908a6785bc8e067075fd8e9f03be87a8b79bade26b9137de8760c"
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