class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.8/gbox-v0.1.8.tar.gz"
  sha256 "b4a219a747b8917515c8ddd2e25bbf688bece9a0f1cffda2068b9f1b78613abb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16a2fa965094faf47e170670b9bb1577647fb9b0520413307993fda79a44b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00e6482f8b8c7691c0c5ef20682502a4e91788af15ba04de77bf7f2bc059cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfcb5fe5e9774c200f69182fbb84e46e4e31dced61833248613f1f22d2c8a657"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ebbc1bc091eb5b1469255850030002f0c2532e2578d39b5dbd3db4f3e9d268"
    sha256 cellar: :any_skip_relocation, ventura:       "19d322d8225961ab43dcf76aa48269daf6f3a5de4fb11c517a5982274d3eb528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb7a657f247ffab923a084c9fa90ebdb44b384ee80cc8c7bbd52e0c77469c8e"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
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
