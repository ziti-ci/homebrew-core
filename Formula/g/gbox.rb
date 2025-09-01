class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.10/gbox-v0.1.10.tar.gz"
  sha256 "7d8cd4e728eac420bd16fcc8e7c6cec1c885adb9370037c24e4497cc36bbd082"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d14e49c49ed6a9b382853f13dc298964feaa4217bb2b1196c72081ce0da0b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e7cb6a15b6d15f5221fed76d3fa83bc1c9f1295cec626e41dd12ff2e4380a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5797f676f87aecb4e3cdd3eb14e1186849a41ee87bffb7976d9f74e88887369f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb8cf9e6890e0aff7e936e3df2ad5eeca650a2227b68444e05a58143032636d1"
    sha256 cellar: :any_skip_relocation, ventura:       "4463c4ab6c3a18da0c1db4e7f1eecb5071a9b7d364bb4fc83506b664be57f6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5ade59eae2f27b95266366275f0e488f769b5ae528175ac074b7e042c9e12c"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # gbox validates the API key when adding a profile
    add_output = shell_output("#{bin}/gbox profile add -k xxx 2>&1", 1)
    assert_match "Error: failed to validate API key", add_output

    assert_match "mcpServers", shell_output("#{bin}/gbox mcp export")
  end
end
