class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "20a93e3ebe89beedab53b53c96779cd38f50b4531508dc9d519a8ce30eda9f1e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ebb0b194213b5859bf0ed9ae88a8d05b660faea0b80294fe058885fb82e786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ebb0b194213b5859bf0ed9ae88a8d05b660faea0b80294fe058885fb82e786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ebb0b194213b5859bf0ed9ae88a8d05b660faea0b80294fe058885fb82e786"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3f395851cd3e809b31c12bb46b51e0b0f410428a5e1ededa9bd7371d3e81258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5a388c9be305991886332a3979960821295f50d9e76546c13757f59258fbd2"
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
