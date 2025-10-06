class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.1.0.tgz"
  sha256 "f9da65d258979704097f6646190473a31080e05909ab54c814b8d902a8938087"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee8a64ddb4d76a23a6e662e0c466d0139d6396bb893d90a4397c23494c88b869"
    sha256 cellar: :any,                 arm64_sequoia: "ca1ab9cf72ab8b91045e9928532738bc6c32c0c3516c824c679f1a31dfcc6f17"
    sha256 cellar: :any,                 arm64_sonoma:  "ca1ab9cf72ab8b91045e9928532738bc6c32c0c3516c824c679f1a31dfcc6f17"
    sha256 cellar: :any,                 sonoma:        "f6261eae2320db8312e88ec28980d2a8e58db997b2f67b217738b48b75812ba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db62c53e70ca8a29702beb925eb4b06689c9c5bb65ac9f629c821dcf05dbd575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6d18c0123e80b6aa5c944d6e90959551b096e97b473159f22f5874bd8ab1ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    (testpath/".env").write <<~EOS
      MODEL_TYPE=claude_cli
      USE_SYSTEM_CLAUDE=true
      LINTER_TYPE=eslint
    EOS

    input = <<~JSON
      {
        "event": "PreToolUse",
        "tool_use": {
          "name": "Write",
          "input": {
            "path": "example.py",
            "contents": "print('hello')"
          }
        }
      }
    JSON

    assert_match "reason", pipe_output(bin/"tdd-guard", input, 0)
  end
end
