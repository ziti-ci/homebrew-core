class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.3.1.tgz"
  sha256 "f79c49e0dd1835b333005fb93870125c214768b96f951fc9049895874eee02cb"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "54690f72523b9aa0c7a09625dd58e268de7371bbca6f902c404346765e44af87"
    sha256                               arm64_sonoma:  "253bed562ab30a0ce5e0300cd5f319f00711ee75c7bd436855a668871b595bc1"
    sha256                               arm64_ventura: "544652be948143187231c3d905e37aaeab68926104537a35644d108a745799bb"
    sha256                               sonoma:        "7b26dd0e8a4ef55127dc2c10689dd2228983883637966259133258d791db1cce"
    sha256                               ventura:       "a38354f289195e203511f60618348178f670f2b9bb305a4778968aad26e8e57e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bb27815beb085da8a20e83593aa233bca5a6d1bd83bbd1e7381b565a38268b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b222a122c921ea65953747c857d5ba41a2b91f104b9d4ce5019e079d2f95780"
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
