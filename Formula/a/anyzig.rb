class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2025_08_13.tar.gz"
  sha256 "13511963d0dc570f5fe47ec83a23ff2982b53f1516076014aab6ec54638c0f3e"
  license "MIT"

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

  def install
    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]

    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end
