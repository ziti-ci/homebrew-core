class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.6.tgz"
  sha256 "6dadb99f5817b39ebe954bffeec256f0df4dc1733e29b6aa36dcec6548fd956f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "bf144ceb369ff05faf412988605b1e28e7aebae528e5d1c933263b5edef7d533"
    sha256                               arm64_sequoia: "bf144ceb369ff05faf412988605b1e28e7aebae528e5d1c933263b5edef7d533"
    sha256                               arm64_sonoma:  "bf144ceb369ff05faf412988605b1e28e7aebae528e5d1c933263b5edef7d533"
    sha256 cellar: :any_skip_relocation, sonoma:        "dec263906f8f4a60ce7aed4aa0bc64de57f530357a37fdc2703f491752f2281b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9989c4007f9fa40994482ec27899326baf97a6809d623ae0ca3820ad0e31839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f22436cddac677d5c009aa1fcd327605456a9ed07422fb6954258d853f779b5"
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
