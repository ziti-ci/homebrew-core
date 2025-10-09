class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.11.tar.gz"
  sha256 "62338a0e72956db48027ea4a023c1ab3103f12864f92176cfb0c61ca348c9275"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "4318ddb65de8568748d77f71eae6ac9628a174a2cb34ef3197e14d5fb1e8c210"
    sha256 arm64_sequoia: "4318ddb65de8568748d77f71eae6ac9628a174a2cb34ef3197e14d5fb1e8c210"
    sha256 arm64_sonoma:  "4318ddb65de8568748d77f71eae6ac9628a174a2cb34ef3197e14d5fb1e8c210"
    sha256 sonoma:        "d33d895af3f2c89aec8f1b51efdb701796c7517058f6730c6e6fb2f8cf5b52e6"
    sha256 arm64_linux:   "e57d378793cc04d84e0dd16fa367e941765e8fd11e5c7282d070ae902c211c45"
    sha256 x86_64_linux:  "9c48ec78a46eec0b89246ed16b334591a1cdbc76a9e5d48fdcf6a921a09d6301"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
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
