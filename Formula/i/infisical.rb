class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.10.tar.gz"
  sha256 "80de97ae14e8a441547c900071c1bc0406c86cdf0bcda325fc6c863d3a4e27d4"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "465a5080910e91d3e1290b4a4f4c0adeb6ea7c98c0b3a108d33309a57af24317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "465a5080910e91d3e1290b4a4f4c0adeb6ea7c98c0b3a108d33309a57af24317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465a5080910e91d3e1290b4a4f4c0adeb6ea7c98c0b3a108d33309a57af24317"
    sha256 cellar: :any_skip_relocation, sonoma:        "9309990d6f4152aebce6ec6c1e488637cc9324c11e55fb95feb62b25056e7c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dc38d739753bef60d1308977a7916412a08bf97616e7544f9a9a9f64017a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31b6f4c7525e13923433aa57f0eb60b6d75e56d1498aa65c28039509b3efbbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
