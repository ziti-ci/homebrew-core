class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.2.2.tgz"
  sha256 "696f19c0b54b0224f131b9c5251441c37ea7ab889e7058acb7f57ae01513fdca"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "1c0ef4f97bb535e5bf58f5c0eefb12c4eb93707d897ab30cec6050dc2e1e14b0"
    sha256                               arm64_sonoma:  "d21388b67fdb0a645829508405918771b52b2c6aa7d18df68e031e1539e60161"
    sha256                               arm64_ventura: "fbf2c95f6451fccbfc34b9231d92ca1d41491c9576f5f8ac01d9cf99568719f5"
    sha256                               sonoma:        "a5e10af4308b92cfbe8a7449d3ecb9e20c9ff8236b45df4779b83d2f21d299d3"
    sha256                               ventura:       "cad08d77475db783162bbc5759ca3677cbf68b915a3029e2059ec6650af05c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0dc254178c3b45d40a4ee1d9e72462605fef322621cc41d1641a75367aba0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa1bc114d7ef8719fc1bf24f0d81f2142999280c316c9ce841691b1432944ad"
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
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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
