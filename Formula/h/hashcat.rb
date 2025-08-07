class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.0.0.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "842b71d0d34b02000588247aae9fec9a0fc13277f2cd3a6a4925b0f09b33bf75"
  license all_of: [
    "MIT",
    "LZMA-SDK-9.22", # deps/LZMA-SDK/
    :public_domain,  # include/sort_r.h
  ]
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "06e83f034f4146c057190a75ea05d9ede88a2205db694dacf643d7e4d88b8210"
    sha256 arm64_sonoma:   "8b1640f18f1fcf6049869f3e461979401f811b1f46d1131676b0732a8b799c7b"
    sha256 arm64_ventura:  "9b4475b3b7384c8186f3e42e1cef42df899148ecb496f1fdea5c1184773cee6d"
    sha256 arm64_monterey: "d05a3da7fe49d7010b867b3fcfd5b71210a4013d1069a6eca4bb1085dec342ab"
    sha256 sonoma:         "2c7627ab1623911e96f599e9c3cd2e7a29fd53ad3df2b280fb9a39433db8ce72"
    sha256 ventura:        "ebba1034f159a47591071da81c48fa08dfd79416599d4540da0b01ea974d1aa3"
    sha256 monterey:       "1f2d0c9bfb3c3b723a27448e9b26377287b4da0aed331c7f1df80e18a29b9089"
    sha256 arm64_linux:    "7534a31d8feb58822f89d3396496d563092652c5578d1c37ebb17afd87cd3f45"
    sha256 x86_64_linux:   "efd1c1f00684129f650a86d10c78873d44535502724731b5eca1976e8624d249"
  end

  depends_on "python@3.13" => :build
  depends_on macos: :high_sierra # Metal implementation requirement
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Add missing shebangs to the scripts in `bin` directory
  # https://github.com/hashcat/hashcat/pull/4401
  patch do
    url "https://github.com/hashcat/hashcat/commit/13a7eaabf8c65eecaf18659a2eefd83d36f9186d.patch?full_index=1"
    sha256 "ad7258e835198c66d793c1b28715e6e637ab52cfa2e0b9e4c400c1cdd479e85d"
  end

  def install
    # Remove some bundled dependencies that are not needed
    (buildpath/"deps").each_child do |dep|
      rm_r(dep) if %w[OpenCL-Headers unrar xxHash zlib].include?(dep.basename.to_s)
    end
    (buildpath/"docs/license_libs").each_child do |dep|
      rm(dep) unless %w[SSE2NEON LZMA].any? { |dep_name| dep.basename.to_s.start_with?(dep_name) }
    end

    args = %W[
      CC=#{ENV.cc}
      COMPTIME=#{ENV["SOURCE_DATE_EPOCH"]}
      PREFIX=#{prefix}
      USE_SYSTEM_XXHASH=1
      USE_SYSTEM_OPENCL=1
      USE_SYSTEM_ZLIB=1
      ENABLE_UNRAR=0
    ]
    system "make", *args
    system "make", "install", *args
    bin.install "hashcat" => "hashcat_bin"
    (bin/"hashcat").write_env_script bin/"hashcat_bin", XDG_DATA_HOME: share
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"hashcat"

    # OpenCL is not supported on virtualized arm64 macOS
    no_opencl = OS.mac? && Hardware::CPU.arm?
    no_metal = !OS.mac?

    args = %w[
      --benchmark
      --hash-type=0
      --workload-profile=2
    ]
    args << (no_opencl ? "--backend-ignore-opencl" : "--opencl-device-types=1,2")

    if no_opencl && no_metal
      assert_match "No devices found/left", shell_output("#{bin}/hashcat_bin #{args.join(" ")} 2>&1", 255)
    else
      assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin #{args.join(" ")}")
    end

    assert_equal "v#{version}", shell_output("#{bin}/hashcat_bin --version").chomp
  end
end
