class Execstack < Formula
  desc "Utility to set/clear/query executable stack bit"
  homepage "https://people.redhat.com/jakub/prelink/"
  url "https://people.redhat.com/jakub/prelink/prelink-20130503.tar.bz2"
  sha256 "6339c7605e9b6f414d1be32530c9c8011f38820d36431c8a62e8674ca37140f0"
  license "GPL-2.0-or-later"

  depends_on "elfutils"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "-C", "src", "execstack"
    bin.install "src/execstack"
  end

  test do
    cp test_fixtures("elf/hello"), testpath
    assert_match "- ", shell_output("#{bin}/execstack -q #{testpath}/hello")
    system bin/"execstack", "-s", testpath/"hello"
    assert_match "X ", shell_output("#{bin}/execstack -q #{testpath}/hello")
    system bin/"execstack", "-c", testpath/"hello"
    assert_match "- ", shell_output("#{bin}/execstack -q #{testpath}/hello")
  end
end
