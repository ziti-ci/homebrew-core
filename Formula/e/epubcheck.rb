class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.3.0/epubcheck-5.3.0.zip"
  sha256 "6c07e68584b2e2ce2f89fe06e1246dfead3eb36b46b340e7d93524f29dcff6c5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad5ac9fa8cf59163ab7261ae951682ed275478c220724e417966ee68b529af9c"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
