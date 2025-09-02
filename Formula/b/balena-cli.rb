class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.3.1.tgz"
  sha256 "39d9d259596bbcfe906b655853b1ef824263f942dd301a89869940c4bc8e1e22"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "0a936a829887f612806a26914d6ceacd71536fd44ff494a61098834ae990db83"
    sha256                               arm64_sonoma:  "719084b46e9fa9345911f6c1e3122902a592cb0c311af4b3f18c9a9c42d0b0a5"
    sha256                               arm64_ventura: "7564bdad9b9851c6254e0b2774ab45312f3d7702fcb24ef4c73e2c4672be44bf"
    sha256                               sonoma:        "81e3038fd27d89261f56c8494ced65c03c2179029b0e207bf7a79779b0839fbb"
    sha256                               ventura:       "6460673549687acb41154754f162fc6bdbac09a8cd5ab753f486fb4494d7fe4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d459f38fb506fc1f947469e11a95142f8ff802c9b5fa0777ce068803fb34de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e517f60957d4b37492edb0435aea63a731ddd8da124652ddbf496ae570aeb868"
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
