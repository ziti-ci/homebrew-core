class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.2.tgz"
  sha256 "8f6c2aa7730e18bbc237ad2a0cbccf159a033140926719f5d3fcbc5f3c3b86e6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b8ed31b6249a03bedaa5d7adde0b582f796056a7134f3bfc4eedc30549f9f631"
    sha256                               arm64_sequoia: "b8ed31b6249a03bedaa5d7adde0b582f796056a7134f3bfc4eedc30549f9f631"
    sha256                               arm64_sonoma:  "b8ed31b6249a03bedaa5d7adde0b582f796056a7134f3bfc4eedc30549f9f631"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d95a53a77f6354fa1bde98ebe213f503a832f54af4292f6778b54d3dcc03713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80117cacc3b9a079ffafcc54631086bb3fd8dd0a7c2f2d9c28624710a019348a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b5c679bdb72a6553d4abea9ad92e89428c56762bb2c5e3fef513062c472ba2"
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
