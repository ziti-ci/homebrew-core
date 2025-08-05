class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.1.0.tgz"
  sha256 "df57bce1296a6d0b1716dee6b092ef6d4bf8413be6a6adebae0aa39619d7af3f"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "0131230976ef9b68f88904ac22d664899c27bfc88305d4ddcd576a679d4a79ba"
    sha256                               arm64_sonoma:  "d3cb3c412eff8fe524e2bfc3af15375b27bf4b3db2d85b466339f6d122620dbe"
    sha256                               arm64_ventura: "2bf34341ea5209d450564dcbe0530cc01cb169ce16a353c7e43f5ee7801b2c39"
    sha256                               sonoma:        "744224b1dd02fbfafa8b0022985518e8c1319989f941192d5abdc27b0ddac7e9"
    sha256                               ventura:       "3d4566cf6f4d2caf15733a30fbf2bfbf17b64a97de45a3ca362c30c7422c7062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed838f36eb3be6448385082a325f9a6a41936ef232e859efb56da61112244e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c02ab325a11f7afa7115c1a2d9e7d7b9043193300dd57a8f1f51bca926f6996"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end
