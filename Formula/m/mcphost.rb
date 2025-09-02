class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e612b98931be1c708e6d0df23ce32261a6ffc584a2cc97b7d497e4978cd4f9a2"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db32ead8d59d9ad71077a13574a193be40802d5ae36be5fe39eca66ea1649abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db32ead8d59d9ad71077a13574a193be40802d5ae36be5fe39eca66ea1649abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db32ead8d59d9ad71077a13574a193be40802d5ae36be5fe39eca66ea1649abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb54c650d1147812a97e187657731154be0fe815c88372c9427a1e08e441cf40"
    sha256 cellar: :any_skip_relocation, ventura:       "eb54c650d1147812a97e187657731154be0fe815c88372c9427a1e08e441cf40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc424b53e21f2268de9dcbb857134eb9351e4cefdb154cb1f89c732e77ce7fc"
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
