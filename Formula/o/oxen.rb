class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "243fe6bc600914510c8adeea4ce0f9885aab9aedbd69ab05b73c8f98560424a8"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d319df00729d3c7abd36e71176c47af508d81bbdbf712b523524baba1790306d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4783ad7d4023cac2543eb0c47a113240e45a1b66acf7ed7084480dcc00353bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "216d72182cf2f3e3c34f544ad7438d9f5728be91677950068291fd189a127e15"
    sha256 cellar: :any_skip_relocation, sonoma:        "7265d4a36a1c075a182f1ac9ed42437391b73e4661fda0629723e6a0ee2b333d"
    sha256 cellar: :any_skip_relocation, ventura:       "3a4ca77bf520502fbd3ae947ed0fda68c24fdf4d8ecc6561fe2abfbbf2581756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1489b895273a79bfbd96d0827095271a34fffb67f41a11fde0c83b9b175868b"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  # Remove `procinfo` crate dep, upstream pr ref, https://github.com/Oxen-AI/Oxen/pull/93
  patch do
    url "https://github.com/Oxen-AI/Oxen/commit/d8867a02a8194e986e1c0e6727dcfea46ba8eb5e.patch?full_index=1"
    sha256 "511ef9a4a09ad3627fb6a9adf898862e45939529542e07d6c63300f90e74c85d"
  end

  # Add missing dependencies, upstream pr ref, https://github.com/Oxen-AI/Oxen/pull/94
  patch do
    url "https://github.com/Oxen-AI/Oxen/commit/d1961e1b49f094ff0247d75a3e5022f4a1999b2c.patch?full_index=1"
    sha256 "2eae56fd15abae3018e211a670e8552fff233893e4fdc9ce357415cb922feb26"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
