class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "fb8940d735e54377c365ae2d07a41f199058a8bc3500b2bedc65e433aecc42cf"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd487c7e22078c992c763d4160b5635d0256057352d71f2a29df8c8356ca662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54688d49e68a33cb6c33e1789ea09d583ab844986449ad37f34197ea3f18b745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "614fb25514a69c962820a0bff969fed72157b1e18dff80c5601fae386b976431"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd5191a7ef74f0a84ba4361c23a7cb4e003f4622de2e5d45ce029c3bb0a8545b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6005a116e5ee85de794f3e43db98366928b075c71076eb61a66dc4483a6690a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea7eb655c9094be0b7bf0cc222afc00e673191f482e36d09952e613103aad593"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
