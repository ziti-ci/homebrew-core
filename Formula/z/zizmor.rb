class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "98a4d8bca8f73a569cf1621042b09d1f48b5a2962e47c570c0f4b3138671e5db"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed86cb4e9bb083ee777b33bf9a6dcfbbe153c0499ad9b7cf817aeebf4041e18e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4154c90e679632960d100b329e80d2e6b87cfa71ed20782b96b1286945c2509b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8332f528f0bc1e4134c87905ee97acc2aa0c50aca26875b3f1e108046438fb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bca4a3791b5e93b0ac35154035ee221c33bf6c273aab1279e03f97da35438e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d952d660821f2fed2be1c21580ec60e948e29f4cdce840c161d8f590a9de7997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7456677a6c5ce1f5b4a665084e5e811d41f29bf8f53c5769d8ecadd88c0f622"
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
