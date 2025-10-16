class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.16.5.tgz"
  sha256 "8a8631e44db3277259a3a6bfb939574e63d388c820220dfe4969eb2b0ed48fc9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2a0bc3446097b44b6d2293600045de2386badb2c51ab82be66ac816292178951"
    sha256                               arm64_sequoia: "2a0bc3446097b44b6d2293600045de2386badb2c51ab82be66ac816292178951"
    sha256                               arm64_sonoma:  "2a0bc3446097b44b6d2293600045de2386badb2c51ab82be66ac816292178951"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e0f23d05e7459584f020bd493eb713d8f2a41fc5d672bf05a7f7dcd712827b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36db38cfd6e6b4fdf6d92a81d579470df853a15513803182138e2adf956584a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a91c2e9f5e567dc14b79ca76b46f2c141410ca756dc8c4a37817ecd64db3575"
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
