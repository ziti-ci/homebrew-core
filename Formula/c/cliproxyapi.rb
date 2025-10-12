class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.2.tar.gz"
  sha256 "41e46995cf496d48e5e9230bfed4e1c9a5d0847885a7e3e48dc24a2a4ae90f18"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6be0b53d08646fd70527eb16f06cc2c5928f0a57742a3957bd8b5208561cf03e"
    sha256                               arm64_sequoia: "6be0b53d08646fd70527eb16f06cc2c5928f0a57742a3957bd8b5208561cf03e"
    sha256                               arm64_sonoma:  "6be0b53d08646fd70527eb16f06cc2c5928f0a57742a3957bd8b5208561cf03e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3febad01af4478ed006c4410fe64d37d09c3ae12c065876904aa94055e045ec"
    sha256                               arm64_linux:   "996bcee5029fec20e97f3a3492a43028828ec1361d58afb55f21fac59a509c8b"
    sha256                               x86_64_linux:  "d5b6dd9ae5f01e5906de3c806b7335486f6c1f274bb4840eedcb7d34a4a9850e"
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
