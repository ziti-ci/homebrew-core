class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.1.3.tgz"
  sha256 "3991b3d7187e14fa1f86ad8590ba248095e1688363c6abfc2c66a7bff1ca0921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a7f74c9f9321d38b353696c537cda8d521e0ecd2585e5f61698d7086f7aa5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7f74c9f9321d38b353696c537cda8d521e0ecd2585e5f61698d7086f7aa5f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a7f74c9f9321d38b353696c537cda8d521e0ecd2585e5f61698d7086f7aa5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e988abd7060bac8709be09bb755351b6680f047ac07163054080c681b3fbab7c"
    sha256 cellar: :any_skip_relocation, ventura:       "e988abd7060bac8709be09bb755351b6680f047ac07163054080c681b3fbab7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb73e884666f1b8495c7bc0863f122a9b4633880ac0e4ed8c064fa1a7ee011b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5519913e5134878f9bf0148f8a498117d604ab5fc5e2c7ce97db22692aff10"
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
