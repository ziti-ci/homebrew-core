class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.8/gbox-v0.1.8.tar.gz"
  sha256 "b4a219a747b8917515c8ddd2e25bbf688bece9a0f1cffda2068b9f1b78613abb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afe0ba909129fa1a2d106073a8e070346d9d3a844f729470393cd52754bf87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da8fa68d3a889dcdd945b5042e1593cb5cbb4edd64b00490774bd10dd838292"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6f5e8387335509b236a22b93513dd055428dfe069d8031318a56402870df343"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a64ab0d26d0be78177e1b2d0175bbec787e37207bed872b7f0ebcb48bcb606"
    sha256 cellar: :any_skip_relocation, ventura:       "a7be5a1c87b2900a1efe5edbfdc55e19e664b9a4a44edf8c5ceca0dbfb83a065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25dc88f8a12b132aa7c7db8e311ea099b97655d60d5dd15a8f2a486fb74e5dfd"
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
