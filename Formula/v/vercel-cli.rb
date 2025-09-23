class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.3.tgz"
  sha256 "d476c0d95e44046f86115d64b758efaac298dea1b102d6dad57fe4c008b8d308"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bf00af81281205c4fd9783d906a400f56917b2b489a0d2488868f7fa156bff9"
    sha256 cellar: :any,                 arm64_sequoia: "836ddc269e0033856dfe885106f324073169ba11c73a921779c83e4776e7917d"
    sha256 cellar: :any,                 arm64_sonoma:  "836ddc269e0033856dfe885106f324073169ba11c73a921779c83e4776e7917d"
    sha256 cellar: :any,                 sonoma:        "97cc4c96e7aad747e5febe9cbd17f327a70dd91bc741d6de021505b3baa54f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78fb9be46cf92cdc69e316d4e360f0437ed135a7426933930f4f79b9dea9fa6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcde683801e166fa1c4cae7e9df1453614107d97cd498f44541d79d383aef2d4"
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
