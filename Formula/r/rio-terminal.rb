class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "b4849138ea4be3d8ff5b5d79463a0bfc6085f8470b3566ab18368fa966901d68"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916146e9f365f6a6820eb9bfe8071f6c924092a5a98da8e5a6afe7f0199c70ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "576b536d054fa5ae7406790793a744122c94b97f6b6dd435dd78b17547811f17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e71d95dedcc2047abfdcb8b9837e2d3b09170b5e19a7ed650313595b5bcef1bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a490ea7b42fdedb4791ad79e3ca4239aa56b0256bc2b900a502385e52ed5a4d1"
    sha256 cellar: :any_skip_relocation, ventura:       "35782a8d07f7f0a309657367e1a83ad035638e188933388be0c2b3ce531d2995"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end
