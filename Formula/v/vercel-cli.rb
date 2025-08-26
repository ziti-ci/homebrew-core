class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.4.tgz"
  sha256 "d0cd4f7e228c1c79a5b9745b30c37767e6be7b930a9ef47e1669eebae542b5d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa1fb998c5f3e1f001d8f64639b521b5bec5be188c0c3e1ef4c15a6c7844911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa1fb998c5f3e1f001d8f64639b521b5bec5be188c0c3e1ef4c15a6c7844911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaa1fb998c5f3e1f001d8f64639b521b5bec5be188c0c3e1ef4c15a6c7844911"
    sha256 cellar: :any_skip_relocation, sonoma:        "a93100e144321fa081f9bb619072e63248c81191f08b80b61c0ff93563984acf"
    sha256 cellar: :any_skip_relocation, ventura:       "a93100e144321fa081f9bb619072e63248c81191f08b80b61c0ff93563984acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "306bf93c4c2e39a50cd9cdbcf071baab8e031ce3794267eddb70fa30c7e53b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b680c068e20b49dfb25dbbc431a82b9d86bfe0fdbb47ff98ecc3f1e92602072"
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
