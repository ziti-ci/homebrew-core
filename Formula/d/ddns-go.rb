class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "59f5a705f08f539c011e12c01b4e82791130bfb4ccfb332f2b6545945fa70e38"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8e817123ad15e540b808e7d716f982c715f8b08f100c8ae2da2ef63dc793b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8e817123ad15e540b808e7d716f982c715f8b08f100c8ae2da2ef63dc793b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e8e817123ad15e540b808e7d716f982c715f8b08f100c8ae2da2ef63dc793b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6cbac29616a54195e53f165f642cd0ff20f530a1ff229e5d224bc8aa722b047"
    sha256 cellar: :any_skip_relocation, ventura:       "e6cbac29616a54195e53f165f642cd0ff20f530a1ff229e5d224bc8aa722b047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1263e1787182e5fb7e13f54908ec2c5ac3eb61e5fdbbeb2be662a7a6727dbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end
