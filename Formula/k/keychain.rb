class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/danielrobbins/keychain/archive/refs/tags/2.9.6.tar.gz"
  sha256 "7fd260679bfc86f10a66e9411b098848c5ec67aa7d129017e355a8d91159af0c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "426ab593c7a025a794d941bf562d7bd1f9505d43c719962d97f351b9602a74ae"
  end

  def install
    system "make"
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end
