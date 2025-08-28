class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.12.11.tar.gz"
  sha256 "f8733d281c4d9f33742a94f01b3fd85c2d7ea20a8417901ba534f8241d906fcc"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1f505feb23e045bd627377aba1ee80ff2be8db2f066bac2e2e53ecb51c41ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e715392affe9e566f8bc3b0074c8c5b3f8cde9bc2393418e04a796ca397b769"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eb9f6799ff54b97337698efcb8eeaf99519404e865b62d3c442401e61fdab22"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfcd9af285585d33a7f3d430acb7b4708cf71278cb73428baaedf504092e3259"
    sha256 cellar: :any_skip_relocation, ventura:       "263ec55d459d71d0d43764e6486a169ff1d4e9c8f11a94393cbf2a1d9618713c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b74d8ffd5a5d4b0587e87a3f5432634a07e01aff8a315521da025fb9854098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba415782fd294751632d2c1ddef668ed9d2dfbc4e0a3fa09584ebd27a3a79fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
