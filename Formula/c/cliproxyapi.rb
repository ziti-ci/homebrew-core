class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.17.tar.gz"
  sha256 "671fe33a82e7b682384028eb349e78932f0eb8456198a287be85e466275e76f9"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "6cd7cc415d397953339f612c5673dd5efe413cccbe7443fe966def5049eb7c31"
    sha256 arm64_sequoia: "6cd7cc415d397953339f612c5673dd5efe413cccbe7443fe966def5049eb7c31"
    sha256 arm64_sonoma:  "6cd7cc415d397953339f612c5673dd5efe413cccbe7443fe966def5049eb7c31"
    sha256 sonoma:        "db22ea676c4973f23e415b50e8c260f9ff9a415707560caac640f564ef88fb6a"
    sha256 arm64_linux:   "daeaabbe2d6daf08cb04af74f37a9adb85d2adf4b221fc3adf5779772cf20a57"
    sha256 x86_64_linux:  "5ca74fecba04183face67871d859f26946288652dc45733cf58ea77e6f933916"
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
