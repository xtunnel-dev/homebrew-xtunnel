class Xtunnel < Formula
  desc "Lightweight ngrok alternative tunnel utility"
  homepage "https://xtunnel.ru"
  version "2.5.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://dl.xtunnel.ru/v2.5.1/xtunnel-v2.5.1-osx-arm64.tar.gz"
      sha256 "74508242eb77a2f20f129e533b44ae80bea99ef27739a130fbef78c7f4b0b193"
    else
      url "https://dl.xtunnel.ru/v2.5.1/xtunnel-v2.5.1-osx-x64.tar.gz"
      sha256 "3a2323320ff3d7ae2d3385461387e77c917cc71eeb2d81d5c3315dcf20019ae9"
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