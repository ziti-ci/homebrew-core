class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.3.tgz"
  sha256 "db20291456161b07470d89da912a42b0c194eeafd0fe8134933049553e31b453"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "908ddf1c7eec55a5102017928a1251ccfe89212a8f633da4641598127ccbc4e0"
    sha256 cellar: :any,                 arm64_sequoia: "0f7881010bc3c6008e590c63b18c7caabca2c141e52cf3767fa343e879672476"
    sha256 cellar: :any,                 arm64_sonoma:  "0f7881010bc3c6008e590c63b18c7caabca2c141e52cf3767fa343e879672476"
    sha256 cellar: :any,                 sonoma:        "183e945c7100f0845a19250e6704167b8f4b5f1b5e9a4a8bf7701e3553bd9270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770d87c8e9f584f4808a6ce1c5be10f85902da4d39312fcbbf3bc269200e916c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c32d190ac8f172616a9074afc9f3a4827c2d26795ef8ccbd3b77923d567270"
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
