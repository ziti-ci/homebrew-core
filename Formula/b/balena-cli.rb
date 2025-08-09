class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.2.4.tgz"
  sha256 "fa3e383e7a42bc58d1c1c668f120656ddef4f1928fd015085ebf36780b456567"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "24d2b0c365a87984a2bdf8b7b775fb01daa8d936ab54dc0be2ae26858fdae434"
    sha256                               arm64_sonoma:  "dc71b7e52473680ada8bb00966354c65cb74ca43a2a466ec40b8ed24c3b45422"
    sha256                               arm64_ventura: "bcf7cb79f822cf9c269bd495c46ce72411a4a200429c476cd9d97ad2f7e776fa"
    sha256                               sonoma:        "d590d663bd8e4423506906df4f3ab8acd4ff5717f4e8c2e9dbae83a7b234c51c"
    sha256                               ventura:       "77b95d83c39189120f1af053c9a4098f05b1a578238b1767cedbfec7b07613d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "963660a5d60a21c9fa6433a40cedf50e50a3001cbd96db26cd5476aa27b24a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20885d5a19325706d2c6ab38ebd4a10692efec019476006ffa0ffaead6c99fd"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
