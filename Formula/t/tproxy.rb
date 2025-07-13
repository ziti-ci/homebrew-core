class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0d5b030c03791882ef077336b689e863b2e41d5f16cdaf8210a76770d219ebc9"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ec0fe223603e2b5f100a9aefd415c8e7c27c7db92aadade292812d0cd14d66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ec0fe223603e2b5f100a9aefd415c8e7c27c7db92aadade292812d0cd14d66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8ec0fe223603e2b5f100a9aefd415c8e7c27c7db92aadade292812d0cd14d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8605f431b78c3cbf0792d2764aed057479af3c93428e872e7aa36249155331"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8605f431b78c3cbf0792d2764aed057479af3c93428e872e7aa36249155331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123df9d7f9259ef84639a7ab4dd1c75e9f1844d1c3044848aad74fec24be5d27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    port = free_port

    # proxy localhost:80 with delay of 100ms
    r, _, pid = PTY.spawn("#{bin}/tproxy -p #{port} -r localhost:80 -d 100ms")
    assert_match "Listening on 127.0.0.1:#{port}", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
