class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.12.0.tgz"
  sha256 "423bb93f9b1158b3fb7cc5c7f175dd2a231446c1bab6704e11d5ed2d3a04808c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9593cbf72dff0d1825a3f6a1cc44edbada7f1903f695f2de928276610d2115dc"
    sha256                               arm64_sonoma:  "9593cbf72dff0d1825a3f6a1cc44edbada7f1903f695f2de928276610d2115dc"
    sha256                               arm64_ventura: "9593cbf72dff0d1825a3f6a1cc44edbada7f1903f695f2de928276610d2115dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3d18a6cd4c8af8497f85dd243ff96bce240009ce17660f1f5bc6681c0ea26d"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3d18a6cd4c8af8497f85dd243ff96bce240009ce17660f1f5bc6681c0ea26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac75c1d196db66fa7cb69b9d3e4326a7d2cda142da316de973999ab4871ee7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e4a3629f5eca4b754efa689e8ed4f899b0c703f8b33e8eb7fa1b47126f0133"
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
