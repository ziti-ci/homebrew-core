class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://github.com/jenv/jenv"
  url "https://github.com/jenv/jenv/archive/refs/tags/0.5.9.tar.gz"
  sha256 "137361c8a25eeabe6f90f435048a698e1c93e5718e0b57069e69f9e2b9ece63c"
  license "MIT"
  head "https://github.com/jenv/jenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0854f8b2d434e292fc9b63a9d59e3bc2643cb7638c5b710db7b0ac2fc5a55128"
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
