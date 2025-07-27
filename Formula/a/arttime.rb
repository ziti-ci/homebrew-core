class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f1418522d36528b38ce604d1a9ec14ddf6284aa6a15d28a7eb5c01a872a6d436"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43985c6cd993f1bd61ef7e392e923b2f9a296dda090156677671cc121cfe67da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a002dd260415fe51b3081fddd4abb65768af8bd3e0d88033a85401c87571abc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a002dd260415fe51b3081fddd4abb65768af8bd3e0d88033a85401c87571abc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a002dd260415fe51b3081fddd4abb65768af8bd3e0d88033a85401c87571abc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "844c38065113abb83934b48df9931113ac1ed289245d94a6f329a4afdeb5690f"
    sha256 cellar: :any_skip_relocation, ventura:        "844c38065113abb83934b48df9931113ac1ed289245d94a6f329a4afdeb5690f"
    sha256 cellar: :any_skip_relocation, monterey:       "844c38065113abb83934b48df9931113ac1ed289245d94a6f329a4afdeb5690f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970e94cdf754fdf21c8e6d05a7281eb9d8b04ac18d7f14282d3fc4356c6da193"
  end

  depends_on "fzf"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    ENV["TERM"]="xterm"
    system "./install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  test do
    # arttime is a GUI application
    system bin/"arttime", "--version"
  end
end
