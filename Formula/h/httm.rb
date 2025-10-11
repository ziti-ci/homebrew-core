class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.2.tar.gz"
  sha256 "b0abe4c4cdcc27029345ffe274aa2512c363075563bd0dd1942f3be95c2a50bb"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2e3356d7377a654ba3e0a3e7364f38421c83866d58934c2ad0482dd205d96a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f028eccf49bcad9a57ba514d11105f1d248916941d5dd7a5430a546b9f8829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d731b59534176a8ee60fad0cbac9cdc3dd3b56f3c2805216132cb53e21511e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "476b8c22fb563318c197d1474cc9bd90d2d48918ccb79ffb7e9ed003ff9ef226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eedbd352f61b6e02f32081f0efdf4ae913681e9c42dfb7341e8971eab1c533e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdfa751d71db1aaeeb5ed68efeb3ef418599af5a5f8cab22883569bd7eced4e0"
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
