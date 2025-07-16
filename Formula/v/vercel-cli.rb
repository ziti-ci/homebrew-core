class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.4.3.tgz"
  sha256 "7be01ee3ff87385b515113f8a78636e9c2e3d5cb91ca29f307f707e7c995032e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3504f68c04e96cdb8a235a15242621f395bb46423331eb5c6d615f227a177c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3504f68c04e96cdb8a235a15242621f395bb46423331eb5c6d615f227a177c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3504f68c04e96cdb8a235a15242621f395bb46423331eb5c6d615f227a177c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1dde43c409c14309fe35cfdc3e081c026898670b91a3170b827844c7ee5f21f"
    sha256 cellar: :any_skip_relocation, ventura:       "e1dde43c409c14309fe35cfdc3e081c026898670b91a3170b827844c7ee5f21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac05fc5525f954c5a2d6b35f67fac5a1d9361216bb3c20ca6715ae3ad55c02dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e023e37a729728f0468464ff370c1782b2b74f586f674c85568468cef2ef0e4"
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
