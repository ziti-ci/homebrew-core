class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.0.tgz"
  sha256 "1f9141816c427f7386cda8c2a196576acaa9595d83189d582531e6df8b0c70eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2d9310fd5549e301c959e1080b5992b5ff3c5b24f018e7b1306566e3a29cba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, sonoma:        "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, ventura:       "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97fa0750d03e58b720e59d4c1aff7e5b5cb1610205e6b05d978dca9efbc53126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9dd0c29747bd7e4e373de2698dff042763f61ff9a803095e378b1fc5aab76f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
