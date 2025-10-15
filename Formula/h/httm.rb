class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.9.tar.gz"
  sha256 "c9d24d296942569408fe5a625a0fbb8d833ffd7d43d56532396d7dfad3033f80"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5737dfc94394e7044938d408880f8dc80a54f4f8132324e763de39df3db187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "024bf967874ea3c605eb2e1a9af5a7c20870443d09125e513c0275e76d80d0bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ab1a9f43ceb8e54133b9eb48a35e0d05605d1b19dfc77b0121ec6ce9f39353"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdf53f4419e312817b385ca7890d9e157d76d97cca03654ec2c981e0e557dbfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a94de073dd912e79560046d0bfcb2fd627cd8e812ef7260d9429856c39170d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb7547107d362d8318399d2da1924418ae3441f8b4840085bf39a2f37e226e2"
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
