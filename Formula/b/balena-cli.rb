class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.2.tgz"
  sha256 "a47668451429c4602501367b404b4471485ec02c9f3470012ff440c0e83a5d5e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "e880c89d02a2340aadc4d03c485b286458e690fb77da394bd5f46e7ca75b1500"
    sha256                               arm64_sonoma:  "ec97344a748e79cb9ad88c435356edd9b33ede1f6015a67be23b32d8c4e83962"
    sha256                               arm64_ventura: "f042b5e06f5f08ad948d667a652e067af4acda1aab51838395fc8c4363b27d8c"
    sha256                               sonoma:        "7074f5a7bb20fe459e4d4433fa6e24be6db967e4476b9c8ad39e0d56f4358e06"
    sha256                               ventura:       "bdfe72115e48119bf41f5182edeef24660f2120f6e44bfd6e57253071dcf8c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d6f687d610b907e9e0fb23e72d0906772b72a0281d179560bf41aca2410357f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418afc7ce97bfd9dea77e9444efbb8ef896383571335a0eeb3d01f95d9caa081"
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
