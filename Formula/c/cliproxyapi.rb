class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.4.tar.gz"
  sha256 "567441ff74e08f71332e98f8edc454025dc8dd872a6e65a8738767b20008c0fc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2ac7cd4df0db2cc1bb6bbdd805292cc1f5583058fad3a9a6da57406201c0e0a2"
    sha256                               arm64_sequoia: "2ac7cd4df0db2cc1bb6bbdd805292cc1f5583058fad3a9a6da57406201c0e0a2"
    sha256                               arm64_sonoma:  "2ac7cd4df0db2cc1bb6bbdd805292cc1f5583058fad3a9a6da57406201c0e0a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "66081b69abfaccaab93bdd72d8c7caa02b0e597c3df4f6dc64b58524277c50fe"
    sha256                               arm64_linux:   "75771ccc83e288716cc1d50dd93b9da276e14133b025082451bd60b29b85c9f9"
    sha256                               x86_64_linux:  "ad63e5701e5b4964d077793ed0f1411f927b3a27088d349bb51cf0ad5b12b4d4"
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
