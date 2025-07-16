class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://github.com/jenv/jenv"
  url "https://github.com/jenv/jenv/archive/refs/tags/0.5.8.tar.gz"
  sha256 "7fa8034dc0900ca01413f94d6d674ad64120c4efd5736828ced54de9f83669ff"
  license "MIT"
  head "https://github.com/jenv/jenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35224b1400c377abd56e99f5e6caec0b48672a935cd3eb250046cf5ab107948e"
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
    fish_function.install_symlink Dir[libexec/"fish/*.fish"]
  end

  def caveats
    <<~EOS
      To activate jenv, add the following to your shell profile e.g. ~/.profile
      or ~/.zshrc:
        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
