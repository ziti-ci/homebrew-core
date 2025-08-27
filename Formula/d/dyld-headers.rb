class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1286.10.tar.gz"
  sha256 "4edc2b4e8c51e7d1b67b27f38036a3f9800d209b8a23aa4d51bfd674d0bda14c"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc98ed0ceecac54e52f03e92dd6e037191e8a5686730e32ce04987025536b614"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
