class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "7071044ed4fc78f1373289ac7fa55c80d59f9dc7fab63700ba9d23201ace715a"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7576dab3b8719a36dd96835b8e8612c67af6dd44df8f65a37345232c1fc7c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7576dab3b8719a36dd96835b8e8612c67af6dd44df8f65a37345232c1fc7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7576dab3b8719a36dd96835b8e8612c67af6dd44df8f65a37345232c1fc7c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71fb7b93cb380dd2b624e3d0cd89e64ea8d857f2b89f84c6ca9dad9ab37d9b6"
    sha256 cellar: :any_skip_relocation, ventura:       "e71fb7b93cb380dd2b624e3d0cd89e64ea8d857f2b89f84c6ca9dad9ab37d9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ecccc420524b47a923217ebe936ae29932fa32d2432c96ca17e9fc99473aed"
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
