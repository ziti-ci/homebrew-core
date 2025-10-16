class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.14.tar.gz"
  sha256 "c4383c3cbda2cd2262c95005e9238d8268c17353b26fdb0fbec0b093716579ea"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "68605004e42b7f8067150f240c80715375e24dfb8c59700e9f9b74916d37795f"
    sha256                               arm64_sequoia: "68605004e42b7f8067150f240c80715375e24dfb8c59700e9f9b74916d37795f"
    sha256                               arm64_sonoma:  "68605004e42b7f8067150f240c80715375e24dfb8c59700e9f9b74916d37795f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2c269975750eacbe7430f4cfbd5533798fcdffb968fb5b883c82c9aab36ec2"
    sha256                               arm64_linux:   "1dcedd45e6acd0d0915e95e0223868918b45e9204ac454139a8f40d88ff559ce"
    sha256                               x86_64_linux:  "54c73d359fa77206192e095852a510cafcddbf86766231661289976ae24f8cb8"
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
