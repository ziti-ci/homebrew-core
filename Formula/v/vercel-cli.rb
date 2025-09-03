class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.2.tgz"
  sha256 "1859d89025493c83b89202196bf2d95a1993ebbb3ef7af50f60799bf6f42f345"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ccb1e028293e8c09d433c96c281ba021728f77956242c989a54fcdd582072b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ccb1e028293e8c09d433c96c281ba021728f77956242c989a54fcdd582072b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71ccb1e028293e8c09d433c96c281ba021728f77956242c989a54fcdd582072b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e11fcbad35c5050f773b3903e6e66e571dc1ca752e43cb4579365c318e500032"
    sha256 cellar: :any_skip_relocation, ventura:       "e11fcbad35c5050f773b3903e6e66e571dc1ca752e43cb4579365c318e500032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0222a93e0c72acf1fdf8ba9fe4c01e5f98988e93b547439353f6dfcba9f0601b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70325a107fa6609bb640989b91f15a1374a02490493444a7507becdb8cc3732b"
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
