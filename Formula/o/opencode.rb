class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.3.tgz"
  sha256 "9e6bc174765d084898c64be9297e3705be141a2d3959f238368ef6379088e10b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d96f26590ad73bcb8a715d0387ec76fd24dc38a5023dec2e87e6042b210f8624"
    sha256                               arm64_sequoia: "d96f26590ad73bcb8a715d0387ec76fd24dc38a5023dec2e87e6042b210f8624"
    sha256                               arm64_sonoma:  "d96f26590ad73bcb8a715d0387ec76fd24dc38a5023dec2e87e6042b210f8624"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6b4bcc102a05374abe598ca3e73a74ebd597163d6f261d53f37d0b1630256a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "235834e8c76756f6189ea19f185848b97a5eb841d21efbbb2b322df1aab44cf8"
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
