class Lsr < Formula
  desc "Ls but with io_uring"
  homepage "https://tangled.sh/@rockorager.dev/lsr"
  url "https://tangled.sh/@rockorager.dev/lsr",
      using:    :git,
      tag:      "v1.0.0",
      revision: "9bfcae0be1d3ee2db176bb8001c0f46650484249"
  license "MIT"

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args(release_mode: :small)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsr --version")

    touch "test.txt"
    if OS.linux?
      # sudo required
      assert_match "error: PermissionDenied", shell_output("#{bin}/lsr 2>&1", 1)
    else
      assert_match "test.txt", shell_output(bin/"lsr")
    end
  end
end
