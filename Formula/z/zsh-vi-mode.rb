class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "28cdbc1803cf5545e5e5e4b29db075dc4d45b8c498bb6118bfff5c7df1b68622"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cc8533232ab1bd33f01149924620063a71a744fa912c29b18241ab4211b57c8b"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "zsh-vi-mode.zsh"
    pkgshare.install "zsh-vi-mode.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate the zsh vi mode, add the following line to your .zshrc:
        source #{opt_pkgshare}/zsh-vi-mode.plugin.zsh
    EOS
  end

  test do
    assert_match "zsh-vi-mode",
      shell_output("zsh -c '. #{pkgshare}/zsh-vi-mode.plugin.zsh && zvm_version'")
  end
end
