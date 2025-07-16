class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.37.tar.gz"
  sha256 "2864181853a613c1ac9ced55785917f5aa2bb1e800519189fb7d714c9b1cce3a"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7181f5fdd1baa2f1fbad41089fb52f483cb9280eab6937d4a0391c12df84c863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6201e2399c64a3317442fca52ab7c121b25300cac0b87d7048b166b5c176d35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e87181e7ff0784af94c79d9fd8b935519ae5fa02a187a0c71fca32b566e688d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac6946ba0949072eecea136c4d3efe948bfca5388fd1104fca844b31199b15f2"
    sha256 cellar: :any_skip_relocation, ventura:       "4d7453a879b6f34bda144ce6bc16c2c5c99240699775d1a58e853fac3fbe6dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0bdb17a5c28f256079750660a5cff5bd41df4792cb9344cea869044da82d274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f44b420d51aa4ea3d160a55d7f7cc7d8fd27cb4fa974ca0fa2ebda3c79f77364"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end
