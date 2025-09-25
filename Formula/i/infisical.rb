class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "20a93e3ebe89beedab53b53c96779cd38f50b4531508dc9d519a8ce30eda9f1e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84998b7c4308436d41bb7d4227c85a300a04f25b095e8e26f032ba5c6e16304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84998b7c4308436d41bb7d4227c85a300a04f25b095e8e26f032ba5c6e16304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c84998b7c4308436d41bb7d4227c85a300a04f25b095e8e26f032ba5c6e16304"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a01c4205ee1b0622f297ca52e4253d44fda81dfc9ec5e714e6129002af35103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "139bee269fc8dfff13b6cdaaeecc05a13fc2eebaf448bf2a0eeb28ee441e8aff"
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
