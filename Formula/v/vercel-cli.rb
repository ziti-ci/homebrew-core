class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.6.tgz"
  sha256 "c71a329bcfea27f1d2c4fc89f94056265de39e2499ce9e097a2660bad7829b18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48badccbefc0b6f8629e3e02f56be73f71ffbf1b265db5f5b62f9e4348af508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48badccbefc0b6f8629e3e02f56be73f71ffbf1b265db5f5b62f9e4348af508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d48badccbefc0b6f8629e3e02f56be73f71ffbf1b265db5f5b62f9e4348af508"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab58f7f77bd625f108a50968d98d72e03626fc986b5554430ec3ad45baa65509"
    sha256 cellar: :any_skip_relocation, ventura:       "ab58f7f77bd625f108a50968d98d72e03626fc986b5554430ec3ad45baa65509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e82eda8e4d9e06c5ffada8a9f7d57892ce01a7743e58fd7edd347fda2b943a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a279766b349daf78d156954169c313730f7cd4161013bba8732387edccb5e1f"
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
