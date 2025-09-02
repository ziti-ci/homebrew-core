class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "bd5080e4b418e07fc8a6c1d239fc412faf70d102b6585e4c76d15115d6c87c23"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ef4442a179654939a6ac388ecd8bf8f6f8af7ec95ae0df8d0200de5747ac7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c71255448a1e8a14bb7bf049cf718ed6c3baef7ed82eff8716e8035235594d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b83235ff457264e5266902c438c77977e212369a8896606b7cb6ebecba24a265"
    sha256 cellar: :any_skip_relocation, sonoma:        "59650b9707678288dc817c58e03741ecc19db1f148cea6193d56e2773a532af3"
    sha256 cellar: :any_skip_relocation, ventura:       "b99a4b3ec976f6235ac10996cdb3f39e28955da4daa871bb867c0eee1fca9120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83ccf66ea4afb272c92c39888c8474b919149166330ecae9a132499bedd965b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ff6a80054cec85a845a5a99d69ae386c2897c18027e11f481ad1f6b484f472"
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
