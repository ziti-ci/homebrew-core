class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.8.tgz"
  sha256 "35618c3e4abee555a2db98a678061d9c7cd3b978f41130862d9402d81f94ab05"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1afbcd02c4e6fbf7a85255902437a1d2019cbe7ab0939683b48d4f5c778791b8"
    sha256                               arm64_sequoia: "1afbcd02c4e6fbf7a85255902437a1d2019cbe7ab0939683b48d4f5c778791b8"
    sha256                               arm64_sonoma:  "1afbcd02c4e6fbf7a85255902437a1d2019cbe7ab0939683b48d4f5c778791b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "57978939794035212be07cba85bcc11d0fcfc0d70bfd849db049f39d8b13c5b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb334bc0f71741edf61dd39c5984cca5be8abf3fafbf6091defa9b8230bd0f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d45495d9499a07477edc18b2b0a30d847c1b825b5456f8c62f70ce3b4c42d0d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
