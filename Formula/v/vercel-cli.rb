class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.5.tgz"
  sha256 "374eb29d41255a7fef91d8e156aa4613e7d873bfa023d419eecc2e64043c1ad6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcadb723c9c32bbd1184dbfcb26c96189de9a20a7a83e66a2bb1143988c532ce"
    sha256 cellar: :any,                 arm64_sequoia: "62a60f2fcdcc65f7361c341db48da305a32009728e439528051c002118d6d934"
    sha256 cellar: :any,                 arm64_sonoma:  "62a60f2fcdcc65f7361c341db48da305a32009728e439528051c002118d6d934"
    sha256 cellar: :any,                 sonoma:        "c73b0212988abe11497ce21225ffc3908220d783dd1af08fc7da1d5b6dceeda6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf185bfd457ca9470dbd08990620761333b6fc8ded2458f91f83ee68cadbfd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3764685bb2512d1b3a700a6f567ae00a140ef6d6928aeea373aeea29dcfbec6"
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
