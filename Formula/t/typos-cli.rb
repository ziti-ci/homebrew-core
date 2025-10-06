class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "d2082786d31e600746896b523f8b2c18c89cff0797bd34c818636e3808ac4d4c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d189abb4dc749383a97dbd988af6137ea8ff8cd48990977b888eead68a6ea210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51a80dc486b91fbf327ef1712012a5abb6047c30831f53675e1572a8e1c312c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85762c911bbdf7312a73f277e50d32f8bed92da40505aeb18c3b5c10d8932c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde731094c9d491ee094683b453d3d91db3f50b0572b782ee1c63467f40fb306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ccb64002f170a10e2c1ffe31a0ea5f972a005702065dd4488ae13a7a33b12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "713300a256992e3a2f08562a7a14a40ba681545550e2a162230fec8e6d4a5e51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
