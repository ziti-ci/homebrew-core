class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.0.tgz"
  sha256 "ae20e266275fd8cf27a46b376f6207990778b0096bc46e3fd198b0c5a1c0e1eb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c61d602435d6dfbc14191f7e848561c6cbf6151ca65a7b67bec034a7cab8087f"
    sha256                               arm64_sonoma:  "0d926f389f673f201ec5b63d7cc8aac11321e0d7ce28f6e351791b5fd23aa426"
    sha256                               arm64_ventura: "d656e0a9ff7b464f1efdaa8055cce2e5ebc0a8fd385aea27a0b943cf6ddb42b1"
    sha256                               sonoma:        "26217e9e855176d40f1ead77d5932a34b08fbdfd6d929c1d1036bc195fc106d4"
    sha256                               ventura:       "d9f6d0c467ae13af294b50737ca08426a2b0e6215e73826e5f5a3afdd93d7cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1a14e056506b0bf9b354907967835a21bc48fcbffadc80c3c199524368f736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bbe4588cb690ffab276e354abbad93f481391bfd44d6ffd1cf2ae8dd4105127"
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
