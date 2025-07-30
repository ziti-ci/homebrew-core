class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "c6b4bc09a6ba01c2af0261ecf16198c4fbc841c5ad21a3bdaccaaf3a56a9718d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e254624ed011e3e198ab5c7e24d3f5c0b5b52fef4ed35be24a4a1779f7cea711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c14a442254815ae15150d5a8d45143f8ff5a1dfd2edc5b54e261af7ef003b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ea135e78e3dd1934556d596afdd275b6df8ec16289b384b9120ecd86d62dd3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb320b3c4e140916bee2728adee4f1580a5a7c1dcc10bee35fc9c09f3a1334ce"
    sha256 cellar: :any_skip_relocation, ventura:       "d8f375092cb828b828c6edb2aaecc2f7f04ef2494146497be8ab2ac0f99c40dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d89c52610eabf98ab92d96602a8e25a2be398fd9b9384bd6d37809f04331af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e7a7576e51ccc787e7cb8aee32044edcdb9c112738dc0dd6a156be130fb15f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
