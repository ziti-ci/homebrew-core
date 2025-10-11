class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "17e257beb8fb7f895112a28e76ab31a518511e68ed0a96ce43e75675c0283724"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "87b5e55016cb98037072fe23792bde9487ed81c54e13f90200a8788b8894901c"
    sha256 arm64_sequoia: "87b5e55016cb98037072fe23792bde9487ed81c54e13f90200a8788b8894901c"
    sha256 arm64_sonoma:  "87b5e55016cb98037072fe23792bde9487ed81c54e13f90200a8788b8894901c"
    sha256 sonoma:        "440d36e6bbe354637d0a4772a33ba6588210d3f36644542b76c2469279d87609"
    sha256 arm64_linux:   "e8dca9e2d6c651e22be7e572144f63c91273f56394a1fdf1d8aa395474827ca7"
    sha256 x86_64_linux:  "06f88195794f9b744f6879f882b6667a3ffe4b1621596ee8175fc27c86c44f7e"
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
