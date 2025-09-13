class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.16.1.tgz"
  sha256 "b77e92ba0d59a6372b6c5041bbb3f866fb85e927df333827f0c7f577c5e1a713"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "921e8be16574b4245a74312bdc4b87c1221d0e32fe79dccef6c8cdc693449844"
    sha256 cellar: :any,                 arm64_sequoia: "49cef4a77db46eaa20c97c0ea8dc6798e6502703e4d15b7c545f3c6345ce0df8"
    sha256 cellar: :any,                 arm64_sonoma:  "49cef4a77db46eaa20c97c0ea8dc6798e6502703e4d15b7c545f3c6345ce0df8"
    sha256 cellar: :any,                 sonoma:        "9ba1ca2ce0bec52a61b96260760d3cd0cd977664f2580a886837aef5f0d6bf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96307570f788ab6697f19c7f5de4f98e458539dc67b4b9ece7ef186fa07584c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96307570f788ab6697f19c7f5de4f98e458539dc67b4b9ece7ef186fa07584c6"
  end

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
