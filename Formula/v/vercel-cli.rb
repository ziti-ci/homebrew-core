class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.7.tgz"
  sha256 "854803e605066292254706b121c1f4ed8153ec59844e4916425b4b72be2adc41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "004be9f4c63571c4f8b26f0db62c37c6551805c255355b5c63d5ddfe136e9254"
    sha256 cellar: :any,                 arm64_sequoia: "73ad9246a7a82a86baf5b33d4720cc52e613354e111b54eadb9872f9ccdc386c"
    sha256 cellar: :any,                 arm64_sonoma:  "73ad9246a7a82a86baf5b33d4720cc52e613354e111b54eadb9872f9ccdc386c"
    sha256 cellar: :any,                 sonoma:        "1f7ffce564215681b9e0673c8a2135b3b9cddc6a03edc12337c8425e281df0ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e56cf30149e040b2f04e68062572f4ebb7171b81b663dc4284e19c2cdbf8dd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62fd5ab3ff164f4d37bb3548ee2d9130cc8563201a7106a4610393927c671bc0"
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
