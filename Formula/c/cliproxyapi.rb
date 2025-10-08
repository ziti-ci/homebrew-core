class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.10.tar.gz"
  sha256 "2c8fdca03aac5fe21d8f4ad92ec71f1d9886665adf4fa43fdb124a5abbcd3828"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "1dd6ab0a8e3d7bb0845e614b939144410d134245705fdc41c794769b8229f135"
    sha256 arm64_sequoia: "1dd6ab0a8e3d7bb0845e614b939144410d134245705fdc41c794769b8229f135"
    sha256 arm64_sonoma:  "1dd6ab0a8e3d7bb0845e614b939144410d134245705fdc41c794769b8229f135"
    sha256 sonoma:        "52b37631917557c1a522db773009042c784cb5a71f4463ae567d864430e89031"
    sha256 arm64_linux:   "5af2d6a35786380ff5e80331035fb1f229e13684ad40c4c2ba104eec602f507c"
    sha256 x86_64_linux:  "195f241e6c04de3de922a3a4dfb632c7fc709c0e92a5e4aa68a0207da1324098"
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
