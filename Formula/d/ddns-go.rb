class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.3.tar.gz"
  sha256 "602944388b645048477e78e55a62d419f0bc83a8d0cc4c372a6b23fa472646fb"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cfeada486f2d183e4c6ca97047a122a412e6fd33074a5ef8a2d6cb180c89576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cfeada486f2d183e4c6ca97047a122a412e6fd33074a5ef8a2d6cb180c89576"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cfeada486f2d183e4c6ca97047a122a412e6fd33074a5ef8a2d6cb180c89576"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1ee9120cc6cf1c5daee5cec8cb44350f0e2abb3f4364a574d2d51a3de7f6a1"
    sha256 cellar: :any_skip_relocation, ventura:       "8b1ee9120cc6cf1c5daee5cec8cb44350f0e2abb3f4364a574d2d51a3de7f6a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893499136a1994817b79bc46303b1b310b572c39b14725654c97db3a3f8491ab"
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
