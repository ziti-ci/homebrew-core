class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.1.2.tgz"
  sha256 "0a99c341c38afe92f2051301cb4460543a5edf3b2108c7aad99fd0e88ec1cf13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4822a2932aa07ced51482a3108f2d0569d7aa60445e9f8854a2df7832e8445dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4822a2932aa07ced51482a3108f2d0569d7aa60445e9f8854a2df7832e8445dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4822a2932aa07ced51482a3108f2d0569d7aa60445e9f8854a2df7832e8445dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4872e3f046158e86227673e59fc485c5dbe42c770903f74af92672f9ee52b131"
    sha256 cellar: :any_skip_relocation, ventura:       "4872e3f046158e86227673e59fc485c5dbe42c770903f74af92672f9ee52b131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7b27a90160fba4ecc5a94b1c48a5358330758e05978eccc5af8cc5173c4bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3507769170acdb16089b67282ab47a1e7804a8b1e604687924a8edcccc4253d6"
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
