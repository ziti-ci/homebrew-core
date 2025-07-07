class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.13.tgz"
  sha256 "493993ebf646aae374917acf85ad9adc0637dcaec1f20fff0dba4886ea4ad23e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8f1ca3d22a4bf1894a7453441e60c6e2b9f69f237d46acf14c3ca5a185dc42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8f1ca3d22a4bf1894a7453441e60c6e2b9f69f237d46acf14c3ca5a185dc42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b8f1ca3d22a4bf1894a7453441e60c6e2b9f69f237d46acf14c3ca5a185dc42"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ebbf6b7341290d6d9b0f3c8f7409edeca6865fa14f74fa05563370a122e26a"
    sha256 cellar: :any_skip_relocation, ventura:       "d2ebbf6b7341290d6d9b0f3c8f7409edeca6865fa14f74fa05563370a122e26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0132afb01691449aad8bcc6c7f6b3754124d098cee72b609b863a6c1273fd39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0b81dd858abe4d51e820de831000620dd3e639b872046a0003e0f890c71b7a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
