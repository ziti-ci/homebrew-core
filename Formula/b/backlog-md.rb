class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.16.3.tgz"
  sha256 "5c10f19fbe59d11fb494cb28bcc3b724f10d5bee50c76e1dc2b4a4cf9db3281f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d8b68540f5fa562316c4f7b68bddb98bcb164f73e207a577f28a4844f208dba3"
    sha256                               arm64_sequoia: "d8b68540f5fa562316c4f7b68bddb98bcb164f73e207a577f28a4844f208dba3"
    sha256                               arm64_sonoma:  "d8b68540f5fa562316c4f7b68bddb98bcb164f73e207a577f28a4844f208dba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7785994378ad2a1afe64cc88f786e82a669bdf6b8ccc7e10e01cb94052aee70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e2d10c1323cafd86d63ddb21c07d535fd36db18a7c6cf031da742115729457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa69fcc51235f4412d88e216d02caf1aade12e24085bde265bccb57bdec8f748"
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
