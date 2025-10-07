class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.8.tar.gz"
  sha256 "59ea7015e131f10139b16bcf47b4066fb1e1d98e988a779a91877869ec3be9a7"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "15bf6fcc86b5091b39e9d2f707f5d89ea828a5f84d540ac8fbf6c544898b7de7"
    sha256 arm64_sequoia: "15bf6fcc86b5091b39e9d2f707f5d89ea828a5f84d540ac8fbf6c544898b7de7"
    sha256 arm64_sonoma:  "15bf6fcc86b5091b39e9d2f707f5d89ea828a5f84d540ac8fbf6c544898b7de7"
    sha256 sonoma:        "a1e4f79049ba29035f1442aec9ef7e85ea12bccffd65785ee0190977c0dc702b"
    sha256 x86_64_linux:  "0a92419edde5ae7e49b8e70a41d5f1643bc9ba0e7e1c90c1d7e1193189372178"
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
