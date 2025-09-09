class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.15.tgz"
  sha256 "80564ccfd641105d8e6d32491f99a210194bf0f1c0ae0032ba5256d187415e4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, ventura:       "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e941cf0c54adadbc4257610997804c112dd3d6c6d8be32cfbc71fa1c4ebf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f813c9fc856f6815e5991db32779a544f1b2be16b4472f9ecdd55641d789f06d"
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
