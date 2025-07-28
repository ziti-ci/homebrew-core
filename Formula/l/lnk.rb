class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://github.com/yarlson/lnk/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bf9f329d194a4f267f2d8684fc658c862ee003f712ba58b75ed970f6ea0368a8"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end
