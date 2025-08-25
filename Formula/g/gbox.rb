class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.7/gbox-v0.1.7.tar.gz"
  sha256 "4fe828140713d863a9995ce0e93f11d20f5b9e46ea1270065842d8bd6363e7d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2113635ccb732f5be0c682e8efce73acfbdfc3462f9130e83b4d5fdbfc6e017c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d8982086b75dea2f212375034a17587d5505fcf9e87ab9199cbbd7bd31bf6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a5ef409f0c4ae987f28a5edbe886de1ad3ee2bf90249ed5a2f12fe4adb6418"
    sha256 cellar: :any_skip_relocation, sonoma:        "684ba7ad892c60f8d4215c0ccc092d8c2b29926799028b32434bdaecf17c3a6b"
    sha256 cellar: :any_skip_relocation, ventura:       "a3c1fa0294630a5cf0c80d7d41c6c661d9205b229cf21f1d855a275c2e3e6ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893dcda533a9f6a2f1b49b00c2be02c8c89a57618844abeb4f63b1dce8ee6511"
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

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end
