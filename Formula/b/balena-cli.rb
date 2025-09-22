class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.8.tgz"
  sha256 "e95dac5d1412833cf720e5052386c4fc463de8826a1da0791fda8fc294f85a04"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "079e582db8e6a893e4f2104666e90871c594bab146b2b492af0c99c1db725f81"
    sha256                               arm64_sequoia: "9cf0eb383d38ed4010a42adcb3584c125cd0936880de7389e542305f0b13093b"
    sha256                               arm64_sonoma:  "75756c0382b5baa29b13f3ec665b689344dde36cb2e153bfb5f4e8fd2ea438d4"
    sha256                               sonoma:        "c15a0d23fca695ec1f64f45e8926d494d37de283c8e163cc99a5f9f3119e2346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e45a48dc0d69c9ae5de659d9dc89c3bac44b0f87fc2c0c90149f1f0742da95d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73eca43f4b70b4b296c99552d61794209170a97cbcf0f7c7da7fa02354e83e6"
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
