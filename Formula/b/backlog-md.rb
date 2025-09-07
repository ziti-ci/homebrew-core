class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.10.2.tgz"
  sha256 "d394165f41bddcfa2c73ce5cacb5408845803fd0d674c278e3343709aea10f0c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "f12215f1bb1eb6bc7bf4aee87c135de86bfac31b71a8309fd2213d03d01c3932"
    sha256                               arm64_sonoma:  "f12215f1bb1eb6bc7bf4aee87c135de86bfac31b71a8309fd2213d03d01c3932"
    sha256                               arm64_ventura: "f12215f1bb1eb6bc7bf4aee87c135de86bfac31b71a8309fd2213d03d01c3932"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b4a40440ef0ab00aae44b93b1f53ec118b1b9664bba944f39d43284aa0f013"
    sha256 cellar: :any_skip_relocation, ventura:       "f7b4a40440ef0ab00aae44b93b1f53ec118b1b9664bba944f39d43284aa0f013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e5ad9669b0b950d77f76a0f151e77ff48114e0e3980cc8b024ba30b9412d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af8397f4002470ada0ffbc3b676ebb088ae8bace18d88190e339acc03908f76"
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
