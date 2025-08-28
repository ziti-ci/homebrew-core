class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "475acd61bff0b6ee4ec58aa566b442355e88d9efe18267c58c1501f3fb93f4bc"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422be820b81d0cedbfb08a6c6de26aee2d18f2307833829ae79a4774b7300083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1d30017f1b862e5f80280d528e8f0f3102ac84929e7f027980f6b8bd16820a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cb08557c188026fc014bcf57bc297da41da0af543fe100eb71b283842c5b184"
    sha256 cellar: :any_skip_relocation, sonoma:        "376d725d88c18dbf64ab4009deebc183a4b2743b3ae0f34ee039a1fdd8d319db"
    sha256 cellar: :any_skip_relocation, ventura:       "1aa659603391224ad0c563e549c9332654cada9abfe2bae30e6a85099c4ad629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ead6cd51ba7953a0dbd2f5ccb910ec5226ce0eeb5ad88ddf900570f97586305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7028d774eb8df2735903c1b85e789c1df4f260c7e82fb6ee4b39f272e97dce2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wrkflw")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
