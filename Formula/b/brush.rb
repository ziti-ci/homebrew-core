class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.2.23.tar.gz"
  sha256 "e1ed28bcc77fd58a8d3927a0409d6e31adc4991b1d54f567eeb804b37cb0f45c"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ea36d90bfe2fa69a0d50d6f6c2657e9d16d49eb2b8011f559fee1141cf547e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22939d1b2fc4b6e363e24346b27f491c9855cc0dae1a6da166011e22820af942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "581177a84ce4ff3370761f073cbd484d2e1ad82616422ec4c10deb4e3d87243c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df828b5b2be7725a7a5d63325971345e175d784c7ba5300fa6a5dafe723130d"
    sha256 cellar: :any_skip_relocation, ventura:       "804020919b073d8ccbfdc00e42aedc88d9163624db2c7100037730f6d56729de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef16c59c2c7abdd38a62463f05488bbd11816e2aee61916429342824430553f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b25c00f06d580a8c3616cf81a3148f72f91a6fb374977a502ee6c99746812d5"
  end

  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end
