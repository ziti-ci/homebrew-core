class Lazyssh < Formula
  desc "Terminal-based SSH manager"
  homepage "https://github.com/Adembc/lazyssh"
  url "https://github.com/Adembc/lazyssh/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ada257fb07db602e92c9c2a3183f267b63fb8e1bf80c4d3292461a003aa794d5"
  license "Apache-2.0"
  head "https://github.com/Adembc/lazyssh.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    # lazyssh is a TUI application
    assert_match "Lazy SSH server picker TUI", shell_output("#{bin}/lazyssh --help")
  end
end
