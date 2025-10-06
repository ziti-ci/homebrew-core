class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.21a.tar.gz"
  version "0.3.21a"
  sha256 "0eefdf2c06264dd35669581b597f4a2b75cf48e81ef8c786cb2de45dde9566cc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9c96254eb823671e33e45e79191a4f7d0f5c29d30e3a9230e7bf1c1789f791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb26697ac201ede86161474f2b09f9a70f096c24403f2474ed73fadaa76a39c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db5907329a848464bbe025242a10f2df79acb47579e2aa10ae9a69335f3725e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1cff2a49fdd4d1b4b578b4a2ad8e8658864ef603d26f296d01479ccdb020b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78a9d7dd15a87f7bc2f688b84048f1865075da671dfe9aec2089ce8eafb1fb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc9063deba70aa8aebfd4e5a656fc2ffc0654912651644798558f4e239210f5"
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
