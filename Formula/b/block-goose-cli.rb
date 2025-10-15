class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "fb51a4e8fd87d04d5b53d6364f1a2cab1dd68d034b193c090508ebfc048097cd"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "331c714e4184928737aa218a520164ac596b41a8b3a94209e6694abfa61257ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b3466d10b14ecf853bbadd4de0c7b04b7f3815e0dbde678ad6a607cb65ddf9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0829395c35db8e2fa1a8832d7edaaafbf390ed046745fe1698941aa12537e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b90ceb1fe068b1bdba18857a719be99f4f850771712953f52558e43409e3c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed3235f090514e8cfb4efcfce69c38e280d60b76ec00b0a8dfb8f8ce0130c9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36e6abf1adad38d529c8caee72499daf326dd0c5229db762b21b0191a1bd788"
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
    assert_match "goose Locations", shell_output("#{bin}/goose info")
  end
end
