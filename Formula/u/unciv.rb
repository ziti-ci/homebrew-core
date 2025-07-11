class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.17.4/Unciv.jar"
  sha256 "818de0e741dd5995de1377215e17d3a1e13f5f165581866922b7ea72a564db60"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03f5234d294b0281999c322df741fc2be50e93ce720b2e81fa45b0de70f98c64"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
