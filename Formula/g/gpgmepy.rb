class Gpgmepy < Formula
  desc "Python bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgmepy/gpgmepy-2.0.0.tar.bz2"
  sha256 "07e1265648ff51da238c9af7a18b3f1dc7b0c66b4f21a72f27c74b396cd3336d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepy/"
    regex(/href=.*gpgmepy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def python3
    "python3.13"
  end

  def install
    # Use pip over executing setup.py, which installs a deprecated egg distribution
    # https://dev.gnupg.org/T6784
    inreplace "Makefile.in",
              /^\s*\$\$PYTHON setup\.py\s*\\/,
              "$$PYTHON -m pip install --use-pep517 #{std_pip_args.join(" ")} . && : \\"

    system "./configure", *std_configure_args
    system "make", "COPY_FILES="
    system "make", "install"
  end

  test do
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
