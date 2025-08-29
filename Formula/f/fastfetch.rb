class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.51.1.tar.gz"
  sha256 "38755082ff0f7123616b98de5f032de76d0cc5837b5204cf5c88ee6c52a77bf6"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "aebd71914e67b89d5782f940e2fb0bc61f0b2bfdd8d4e5ce4419377b1e6d28f9"
    sha256                               arm64_sonoma:  "62b2bc0ef575b46ef172b0f449a9fd38d381d9999f5c8ced787b856c0494ce56"
    sha256                               arm64_ventura: "c123bf188441254ae23f7fa69c81de8de95c6333e0d1c08b74cd83ac2edf2feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "35221dea247e7210048a2d93bdb33884d560b74352b94f5efb9a902c2ad86a29"
    sha256 cellar: :any_skip_relocation, ventura:       "6c509eb2e2e495349f7e3961a29d7634299cdd8a87484e0dcbb78abc971dee9d"
    sha256                               arm64_linux:   "46196326570032fc61aa6df75c871cf6ef517bfbe4076d1e7017a96d2e683e78"
    sha256                               x86_64_linux:  "9e1c6ce3a0bdca5b4e050c869cb4bf8fcf80abd2f4c315724c28b9e302973c31"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
