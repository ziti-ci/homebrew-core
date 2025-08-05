class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a98b6510c6dd0750380ecd2a7ac577235d01edc79c547f633c006d95ed3de83c"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "34691e86e28c5e23e9eb119afd9e1adebbeb4bd12b6a4ceb31b4c49a2df266df"
    sha256 cellar: :any_skip_relocation, ventura:       "34691e86e28c5e23e9eb119afd9e1adebbeb4bd12b6a4ceb31b4c49a2df266df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc25e445d154bbf337cc0fb92c085d3e56232606a4198ca6ad0c1afcce474ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
