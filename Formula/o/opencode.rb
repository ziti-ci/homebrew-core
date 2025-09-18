class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.12.tgz"
  sha256 "215d974acdff606e2e201d09a26f9df1b44c8218ecffdbad8be6232ba2f8947c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f45be35d095a90925b42e9f956898c5782c784de3d42877d4452e73a50de9f79"
    sha256                               arm64_sequoia: "f45be35d095a90925b42e9f956898c5782c784de3d42877d4452e73a50de9f79"
    sha256                               arm64_sonoma:  "f45be35d095a90925b42e9f956898c5782c784de3d42877d4452e73a50de9f79"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5af369b18bb9d92e1a62ddaf1085278538e8176db08ed53fcff1b59e4dee00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a1cd6b736fa5ed9905fb1f76a7668f307d4e9a094096a9971f8fd9d1c460522"
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
