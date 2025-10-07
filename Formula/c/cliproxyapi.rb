class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.5.tar.gz"
  sha256 "7647f27ebf152f083f1dab68dbeade7f7aa832245cc7b17d5693134d4198deb1"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "7a6af0493e07afae08892670cbf9ebc5e22d021e232982ff7f04518ec4e126c3"
    sha256 arm64_sequoia: "7a6af0493e07afae08892670cbf9ebc5e22d021e232982ff7f04518ec4e126c3"
    sha256 arm64_sonoma:  "7a6af0493e07afae08892670cbf9ebc5e22d021e232982ff7f04518ec4e126c3"
    sha256 sonoma:        "110cd1485e6f8175596f27a38623a8d0d74a97d3ae54b48cdd14ee8d26be2321"
    sha256 x86_64_linux:  "1a77dc50a952f9475608096805d675c552877be550db596ccc468fa1bd6f6f51"
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
