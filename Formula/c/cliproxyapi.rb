class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.17.tar.gz"
  sha256 "812b4f011d91d8e876a3effa178f1577975e660bc39cc89dae7882ff8133b7d8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "549b88e35630340df3457ba4b52b5e8c512f83289274973c14cc0d77bbfa55dd"
    sha256                               arm64_sequoia: "549b88e35630340df3457ba4b52b5e8c512f83289274973c14cc0d77bbfa55dd"
    sha256                               arm64_sonoma:  "549b88e35630340df3457ba4b52b5e8c512f83289274973c14cc0d77bbfa55dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3523c324bc4c02ffc876d02d5551290849fbb367459bde6aab8159525d79b994"
    sha256                               arm64_linux:   "c4735e834a3bca7ffe462cab89f21daf137f9ec9a5dd588c0011646bbcde185b"
    sha256                               x86_64_linux:  "a55848aa9f149fa9dde811c623b22bb994b0e40a11e484bc151af1a480d6707a"
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
