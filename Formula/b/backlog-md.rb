class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.14.1.tgz"
  sha256 "866572a1fc49a0f55546048aeec4eb430f161d95618e592f3b5f2e7f434574e3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "63d9a9ae38ff30b8ffb7551890d95ff7a09497facc4d520d60bc5602e5717774"
    sha256                               arm64_sequoia: "63d9a9ae38ff30b8ffb7551890d95ff7a09497facc4d520d60bc5602e5717774"
    sha256                               arm64_sonoma:  "63d9a9ae38ff30b8ffb7551890d95ff7a09497facc4d520d60bc5602e5717774"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e9a2703a999e0b5f2f7600a2a86cd008f62bd260bf5ab9407c3100fe163cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf03ab1a840a266d1fbe1a681ebcd7fbb34f25496c4c3cf49ea54ff1a8834224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb72f931be10a9e2ca34049b9167d31532d3c29d2fd09fa008ad8203d6c0e5ff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
