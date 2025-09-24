class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.7.3.tgz"
  sha256 "e0da1a03f1f59ce2ad2138b0cc4b99de0ff25d24ee6c0bf709253416b0852b2d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1d9f93302210d82840ebe71ebfee53c148ce925fe85da14e82124df0c111d7a0"
    sha256                               arm64_sequoia: "893d0efdde6d5ffa0a9f3619b2868607733ebf79906a6c4a4752e42a9280382c"
    sha256                               arm64_sonoma:  "17d85f3e065a68b803fcf87ea854a71bfc5e61f206f1cabdc5560f227727bd1a"
    sha256                               sonoma:        "d810db6f541e8dadab2ddbfd402ab3ee4f0b458389f0043fde55f116749c14d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c47a59530eba1e0ef75936143d2a380ffee43410d42973bc11307877c2348204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89b1a512d8eccf5b44243330df4bb6e4f47bb6b25adb356f7428c4d988adc47"
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
