class Negfix8 < Formula
  desc "Turn scanned negative images into positives"
  homepage "https://web.archive.org/web/20220926032510/https://sites.google.com/site/negfix/"
  url "https://web.archive.org/web/20201022025021/https://sites.google.com/site/negfix/downloads/negfix8.3.tgz"
  sha256 "2f360b0dd16ca986fbaebf5873ee55044cae591546b573bb17797cbf569515bd"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc774cdde317803fe6a9f0b4d63531556e781467b1491407c94fc11509fa0997"
  end

  # https://github.com/chrishunt/negfix8/pull/2#issuecomment-1956815369
  deprecate! date: "2024-06-10", because: :unmaintained

  depends_on "imagemagick"

  def install
    bin.install "negfix8"
  end

  test do
    (testpath/".negfix8/frameprofile").write "1 1 1 1 1 1 1"
    system "#{bin}/negfix8", "-u", "frameprofile", test_fixtures("test.tiff"),
        "#{testpath}/output.tiff"
    assert_predicate testpath/"output.tiff", :exist?
  end
end
