class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.5.1.tgz"
  sha256 "2189d71bd165c7fbc91234121732eff767f3b6394810a4f6602b12006927cfa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40c3e7260ab13bdb75520d31e21792ab1c39c214efe035c5504fb868a517b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40c3e7260ab13bdb75520d31e21792ab1c39c214efe035c5504fb868a517b47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c40c3e7260ab13bdb75520d31e21792ab1c39c214efe035c5504fb868a517b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ad6fc3395100d1379bc2f196a10c48dfabe8cda3bb836c2967421bba607d04"
    sha256 cellar: :any_skip_relocation, ventura:       "b7ad6fc3395100d1379bc2f196a10c48dfabe8cda3bb836c2967421bba607d04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580b3d2ed9185cab9b8d63340fff77564ebecd0003e7bc4daa738c3f5958755e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d39cc64ca746c40b4415b27236ecf71e5da56920d90dc4274edd2b131bc46d"
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
