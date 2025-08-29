class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.39-1.tar.gz"
  sha256 "c0441f21dc5ea365a6d63466070d00e6858aed3b3c42276a1bf18ab3c57c013c"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f66640719a9a4ac39e0eb2947b315e46066c7808ed30d6f9898b18c5b696e421"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    # Build an `:all` bottle
    inreplace "inxi.changelog", "/usr/local/etc/inxi", "#{HOMEBREW_PREFIX}/etc/inxi"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output(bin/"inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
