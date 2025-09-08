class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.14.tgz"
  sha256 "404708930ecc80e96c990d82c542001471bedaece4ac21bb952c55362ab8fb64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, sonoma:        "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, ventura:       "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae1edf784885646f6f1a4f280db38fce54dba15161f0304adf500c7330e5f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35692309e5754540bd400acfc8232362fd69ed77c6f4b247eae71eb749fa935"
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
