class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "b2c64f29272a6f141243f01837111dcfde5f1219e40304dbab0eaca92cde07b6"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cc97a0db4c967dfdba0f9600d72be36096a485627f9d7644ac375d91942826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a7a5891044b693c86b7872a077d07bfd4e8e816b5bcea136879136a9d01806"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0849d47965659ea44ad8a76796e78306fd618d93d47779bce8f93f1a60e084d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a93cdc01e3f2919379e18d98980ca894115fa9c770826d4c772d85a4e15104d"
    sha256 cellar: :any_skip_relocation, ventura:       "18d5f5b0695f7b764e7cbdf3cb2919fc547f7abcb5be8b7da9cf9579498ca9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f59aa98503dfab221c9a14e3dfe6f23b3dd8c22aea0454c8ae5fcca88ebb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a3a5fd7ac3fc02c10ab86ab4cafcf6a39f67b4611b0aab3c7082178485c3ff9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
