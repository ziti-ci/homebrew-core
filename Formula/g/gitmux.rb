class Gitmux < Formula
  desc "Git status in tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "c62b180415c272743d01531b911091b9c35911be4ec4aae3e7bfceddf5094f6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94802a69e31ec9c017fb332eef1427d91c17e87b657db245817a83f5362b3b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94802a69e31ec9c017fb332eef1427d91c17e87b657db245817a83f5362b3b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94802a69e31ec9c017fb332eef1427d91c17e87b657db245817a83f5362b3b21"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f6304b35b33a7c5ffd896df4879fe25fba51b51b9701170f63b31d1f420bff"
    sha256 cellar: :any_skip_relocation, ventura:       "47f6304b35b33a7c5ffd896df4879fe25fba51b51b9701170f63b31d1f420bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72dcb9a4cc65c6949ad3e2cb1d41ae0da46b6c3788e3e92b0efec8b4ea73e443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b685c802a8ccbb422f1e60541c12236b8be7c2c28f275247f2a41d4425e29f"
  end

  depends_on "go" => :build
  depends_on "git" => :test
  depends_on "tmux"

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitmux -V")

    system "git", "init", "--initial-branch=gitmux"

    # `gitmux` breaks our git shim by clearing the environment.
    ENV.prepend_path "PATH", Formula["git"].opt_bin
    assert_match '"LocalBranch": "gitmux"', shell_output("#{bin}/gitmux -dbg")
  end
end
