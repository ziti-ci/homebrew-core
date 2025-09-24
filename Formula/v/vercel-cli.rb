class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.5.tgz"
  sha256 "92bf7c3fb1a72468aa1ce2a751940b544127b5b678554918decaa9e09350b276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cae7984aec864fa4a35efb29b4bbb2fba746e4d7533d3975dc4cef1057e7a495"
    sha256 cellar: :any,                 arm64_sequoia: "e8080a57c7bc61b94b7e6d335b11e210aff6912ba84202b9374b5d97c2aa60e8"
    sha256 cellar: :any,                 arm64_sonoma:  "e8080a57c7bc61b94b7e6d335b11e210aff6912ba84202b9374b5d97c2aa60e8"
    sha256 cellar: :any,                 sonoma:        "b4a69f6c58cd6fdba64a1166922664dde97e49d986f468742165cf33f1e68879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474afc56c6e9b4f6f697e3ecb3ceade705a374f635d1526d2e10621764b93ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e20a393f6b083536814e8274dae3f0e30418c3d3c0410fd51e2408f2f17f9f4"
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
