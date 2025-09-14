class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "48f21b868901ccb23654079fc2929500658d3a76252d3d9b86ee11d4c180815b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e549935b1eba5948c0d64d5fcdc80da9bb3f4e8184a3e9256b29db8443119889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2909ee4d5c2caf2ecd8a59a64c3b5f7fa3a12ad3e9b151a8522cd25c0d148efd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e933b05db7c40bcf41f11ec072ecbd416794b327db2e426e15a42a9d4df11c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b382f9ff91238910ecd56ee752111497dfd6986ae640d640316c3e20e9fbbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9071efba0e21f03c80e973c8195272bca8ef325ece425a2ac2d6ee514f35d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fedb91686b8faa9945e9d0ab6515a521f73739919a0d45fdf0a55b3cc3b3336d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
