class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.2.tgz"
  sha256 "2e7ecf2418437d1b9cf347d29d28e56d244e503ae08e49efea100892934a1429"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c26e27464f0971f891c4fe5d986f91a9147fe34ac61330b78e99cebc9e374165"
    sha256 cellar: :any,                 arm64_sequoia: "8920b73ba2f1ceb799719420ccced8bef0dcd0dcb485010e4e2e26928379026e"
    sha256 cellar: :any,                 arm64_sonoma:  "8920b73ba2f1ceb799719420ccced8bef0dcd0dcb485010e4e2e26928379026e"
    sha256 cellar: :any,                 sonoma:        "3d6966d6a092cef9b6dcfaa206210a8fd19a6414823dfa990754b70324b14eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67b618a0c55aeeaf597cfa9313cd1bc83a9b983d75530cc5fb4ec0e3ac683b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faad0e20bf7e82285401e22f58b54cf60dd400b2babf5032b4ed5643901f3e82"
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
