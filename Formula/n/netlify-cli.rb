class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.1.tgz"
  sha256 "d28903678ce2886a9dc2b5b51411eb59008fcd99c9b0a27fc8a045f7f3a81a29"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "57ffa46af4ba0dd3986b94441cd7bc9c96180eeb2d9c32a0d8faa7eb9956106e"
    sha256                               arm64_sequoia: "127392bdf1ffb4238610b8b477854f61d341166e36aef2fde7698fa58371a7b1"
    sha256                               arm64_sonoma:  "e2012114e7abd59a526e227fdc36a0f2e4d4ec1bce4214b93bf01ed73c87798b"
    sha256                               sonoma:        "fde15986dba3b9a093907802d151a43251e57a98c47d75be71f88b70c10d2389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be90ec798b3ab356a0d93f8f1e1bd3a9bf5f7410fc2022076524830155dc414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d633613f23f9f6e33a1f363136e50af9078fb85262a492e8215251a260b3de52"
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
