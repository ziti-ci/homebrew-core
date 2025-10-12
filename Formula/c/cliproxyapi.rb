class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.4.tar.gz"
  sha256 "567441ff74e08f71332e98f8edc454025dc8dd872a6e65a8738767b20008c0fc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cbc63dead8fda7cafade4750b6c121e75902d4af17d8796b7d3f257028958135"
    sha256                               arm64_sequoia: "cbc63dead8fda7cafade4750b6c121e75902d4af17d8796b7d3f257028958135"
    sha256                               arm64_sonoma:  "cbc63dead8fda7cafade4750b6c121e75902d4af17d8796b7d3f257028958135"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4b854749ac2b566b2d7469bd61c8d9fdacb735a61e27de63ea7bfcefdee4a3"
    sha256                               arm64_linux:   "cb2274a5a445c11014d240c51b42b0791c0b02fb5e4e37c2e44e2f870396279a"
    sha256                               x86_64_linux:  "147a447e5635053506ec5ad114c47c564765b01a8bb57606c891a4a07fdaede9"
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
