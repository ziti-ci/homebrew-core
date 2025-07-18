class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "fc8a90edba59d25b30e5fd6977f3dfb4a4f8e6d633959816cd38c869627920e3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4d5c4870b7520560ecb34a4b2f46a8f57ed71154261b5591762fbd98c5331a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "242e834a4061c14461b2168dbf12875721321898e5c6d65b6cab7a9ae69dbec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ec5c31ceb19a0e8decaf5a3be477679771b66c9b7731523a2f1e01e71098749"
    sha256 cellar: :any_skip_relocation, sonoma:        "908227e810f4692c802bf79788302eb19763bdfbff6ca15ba6406f542876e7e4"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed9355a4e2ddc7f56daf4baf9d29a230765476f2b1f45ad431477b4e0f193ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88cb78f7876257ab97faf4573ab082cb9c857b5308489d840b4e4c41aa48e8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2801bb9b4bbb148484a6be4183937735f5ed314314d18f80b97dddbdf2aa1d"
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
