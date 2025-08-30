class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.7/gbox-v0.1.7.tar.gz"
  sha256 "4fe828140713d863a9995ce0e93f11d20f5b9e46ea1270065842d8bd6363e7d2"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d7b39fb7bb93bfd09bf1d047014b23e7d653441f5c70c9eb23b727810e19c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbbc49559565ee35c585dc2fed0c5733a485f944f3b985486550e57295373bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d30b7ae6868449c2f8f6702fe96a81a22639095832f58f84056f930f3ea6eead"
    sha256 cellar: :any_skip_relocation, sonoma:        "773053a28a937a978c77aaeb86678f16131576fcfc7dcb5baa56c19ca2f1baa6"
    sha256 cellar: :any_skip_relocation, ventura:       "03fa4f93f983e6126ac2daeccdb6139c83f43c177780ac5ae2ae041c64f6a4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54856cebd895e0e7e5cb324c07720168ec3fb0dcec6cadf3470bd0bc706f907d"
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

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end
