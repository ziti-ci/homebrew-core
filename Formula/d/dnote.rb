class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://github.com/dnote/dnote/archive/refs/tags/cli-v0.15.2.tar.gz"
  sha256 "d68fd975a91b1872d15c2bfea12a1b43d8878c9811d1df4876c07f3d10f05e4e"
  license "GPL-3.0-only"
  head "https://github.com/dnote/dnote.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionTag=#{version}
      -X main.apiEndpoint=http://localhost:3000/api
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5", "./pkg/cli"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/dnote version")

    desc = "Check disk usage with df -h"
    system bin/"dnote", "add", "linux", "-c", desc
    assert_match desc, shell_output("#{bin}/dnote view linux")
    assert_match desc, shell_output("#{bin}/dnote find 'disk usage'")
  end
end
