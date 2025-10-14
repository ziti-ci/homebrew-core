class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.7.tar.gz"
  sha256 "a71401f2f8785c2638fb2b8ffb99254807d232dbb0fb2c9dbf10d7c5f6b6f7ca"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "193d50d16c542e16bdccce21004568db908e9d2b0ac35f6e23dde62903f4bcf9"
    sha256                               arm64_sequoia: "193d50d16c542e16bdccce21004568db908e9d2b0ac35f6e23dde62903f4bcf9"
    sha256                               arm64_sonoma:  "193d50d16c542e16bdccce21004568db908e9d2b0ac35f6e23dde62903f4bcf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7093edd4aa0c3c20bf71b9970cca341cf8f9ad95ae3473bba0d92186e958f043"
    sha256                               arm64_linux:   "d58306f1e295aef306b6182088341891e1371f4222c2c4d516b0a8b27ad250b8"
    sha256                               x86_64_linux:  "0935e417c36769cb2631d511057adbf0232ba310203bdbd87f6aad812cc253b9"
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
