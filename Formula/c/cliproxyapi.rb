class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.9.tar.gz"
  sha256 "01a595dcc4cbd9e3ea31015a95290e1f7cb662aa053101b0701a2142c26bc82f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0f774f0df1638c29078d2a8d131ae949af0c2948b2deb527745746bd6f647f7f"
    sha256                               arm64_sequoia: "0f774f0df1638c29078d2a8d131ae949af0c2948b2deb527745746bd6f647f7f"
    sha256                               arm64_sonoma:  "0f774f0df1638c29078d2a8d131ae949af0c2948b2deb527745746bd6f647f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7796f54fa9b25691e67939d3ca6731a11e6fb936a25993e064b30883f86788bd"
    sha256                               arm64_linux:   "d00dd7d9bc8848fe4ba8066ed7d647c206c3fa0314b71d3d25b2ac599dd02a3b"
    sha256                               x86_64_linux:  "2666690efa5e34768549757bea239b2e55950ed713fd564018a030e77b5788dd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
