class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.6.tar.gz"
  sha256 "ffb2f74374bdcfd1bc969b6761b61c19e2fe44042c6445f61393c3aed0241b8b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872747ce87cf4d56e6623ef1629c914265494698fb6185ca0ac9a77d657298dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1318625dd64645355c3db19ea9d8001d016aa51775f74871a580b55c4a27faf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccb7dc73af32d987fe4e1e24b8f9602ca75e42e5aa1cec6c950ff48e0f87c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b98cfbba0a87871403494f084dfe179a2c207958c8c643e434b9f811b63f75b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e88f874d4c5e9c5dbde7f9815eda3772f04ead5a956d4e480827b4f96f68af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d3808d0cab9b0e09a3d739c138a450d1a890d4bfa6438d4b5a9f2e795bdd8c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
