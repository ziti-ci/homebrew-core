class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "f426516ee9e09b19d4135441753a44346664f5769ee8c83b52095b0cded54828"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da443b872a4fa3386a3a9b6dfc382bc7586cf614316442898a504b98cf95425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2bb3ea629b8d3a3cd5ee9b5dd8405429d3025629c9c7d386e5d01d278971565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "884a54778600d0c896845b1c6392f3561042cf8c662a0bb5a7d170f12fb085ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6d176ebbeffaa3f3f3d606362fe859666762e7bbae9bfb5854564372cdb085"
    sha256 cellar: :any_skip_relocation, ventura:       "fa37de03cb184c7f0dc068d0aa4c4fafc507d2293aeb07283a76b22c3a4a235d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f19fe01bcf35250ce8d9380ca0fe5c9b022233aa3bc3e8b4190e93710fbe1ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
