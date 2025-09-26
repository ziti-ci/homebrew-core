class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "22dbee4241ed0ba4b05a664770efa1b900499f536bf5b852c2ec8c2902b77fb8"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdc95e0db102bb87eaa1553f0a880344a8ecc710b8457376be6e347f1a57ef9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad2495955d5e85e882d3cec277d45660a2c26ae8efe9124a4701bdea1192a2f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c26549c9341f9577a548351091e86c3ffa4d6ebc3cb4c36b04df5f800b54d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6154eeabc48e4868012a84096a7ac5207e3c9a312435607ad84b16477ba9400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1c56dbcbe18c6c27160d8704db712d724845d1247650a5e17788329ff1c463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5042cd8f183208806a0617a50fa498fa1be9ba92a8854c86596424bead7b16"
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
