class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.12.tgz"
  sha256 "d36e8cf4482a6cfb93cf2ef6f469d8f486ec67daeb8202fb4d2d31c95849af90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, ventura:       "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404b556f13e4020640b5b3f36b00673c209d86f41c8491705b0c6ecc9efe81e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7dd985a449964c7e85048b68114e6209f291b97ba5fe27d5a53a14c941dcd44"
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
