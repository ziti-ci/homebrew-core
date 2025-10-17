class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.19.tar.gz"
  sha256 "ef9856c0b5bed542a7cef57e9c0f88f6221717a3284fcb87157ae725aeb35115"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "047900f6f5d92b0936b59222610f7c257edeb9ded3454e3f5323e802ff0d1c9a"
    sha256                               arm64_sequoia: "047900f6f5d92b0936b59222610f7c257edeb9ded3454e3f5323e802ff0d1c9a"
    sha256                               arm64_sonoma:  "047900f6f5d92b0936b59222610f7c257edeb9ded3454e3f5323e802ff0d1c9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f1172cdcde617227f07a7415eb2bce5f9ea3ca81d3e763b21c2e8ac9ad0cfd"
    sha256                               arm64_linux:   "1cd5ca20e927c8a15acde577fe0ac8feb59925b8917a8c4a28d29266e212d2b8"
    sha256                               x86_64_linux:  "cca9513d4ef9f8e3b6c696fa1f9705560a282bd9427c5adafdb17252483a7089"
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
