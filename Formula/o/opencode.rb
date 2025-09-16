class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.3.tgz"
  sha256 "9e6bc174765d084898c64be9297e3705be141a2d3959f238368ef6379088e10b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e3f552e62258befef065e4e56ff344af8cd759d79976fab5fab96965f33d90af"
    sha256                               arm64_sequoia: "e3f552e62258befef065e4e56ff344af8cd759d79976fab5fab96965f33d90af"
    sha256                               arm64_sonoma:  "e3f552e62258befef065e4e56ff344af8cd759d79976fab5fab96965f33d90af"
    sha256 cellar: :any_skip_relocation, sonoma:        "6df82f2280a13a599d86d3560c9ef8b9f9e114c0a215bbc89f92f3d4845d4894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e96dcf57dc31e0b1a82eab7d3abea79e78651f12987a8c27002e29b7a9a1e55"
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
