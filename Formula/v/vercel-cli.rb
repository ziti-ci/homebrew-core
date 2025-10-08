class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.9.tgz"
  sha256 "2e49468e47b86ab104e1db2c4929b6870fd1254f6524607779bf94024ed37af0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4e16edf68f81e2f3bd86329060999a43985bc8627df8d3766ebf91f2c52533d"
    sha256 cellar: :any,                 arm64_sequoia: "f9ea7b7d04539f69c65507bff97fceb742d0c84cc88c10f3342c73232ebcb148"
    sha256 cellar: :any,                 arm64_sonoma:  "f9ea7b7d04539f69c65507bff97fceb742d0c84cc88c10f3342c73232ebcb148"
    sha256 cellar: :any,                 sonoma:        "07482c868c43fb7ead8ea68f8eef45b2683ebfcfb37f35e20981092974a0707a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8651d91a299d04a61862f0844c3549fb469058f3c2064925a5f8df3480e778d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011776683ef8013fd99860fc363d5b35c02253f294f638cf67836b35cd733938"
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
