class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-3.0.1.1.tar.bz2"
  sha256 "c1b1b9f37bb907aae5f4bcfc960269baeae9e6710cdd6860ee965abfa2676631"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a504496bc78281f74b2defef09701551f50a3b596411b98dc603c780a231b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f75ed8bf421b5678e5ed4fd89955e7bf0430a05ce3d12575be885954f749c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8c06e5a34671036fc8a03aa705f87c2a0c57d306b7c3a036980bf2c5dcc362d"
    sha256 cellar: :any_skip_relocation, sonoma:        "36b695450709bc29aa15604b803a721250c197d5ff502094662d0450abb945c9"
    sha256 cellar: :any_skip_relocation, ventura:       "ec56d5444019e582af59adcfc89e6f91365b565b8384b2271ccd31ba55581b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16ff1c7ed0083eb5eba597fa97c2f59e043c1cc65a62696b99a45d8dd07687b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a679a33a84b3c50bf58b42cce69f3d418e16162a0623dab8858a59ee8b186adb"
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Shared libraries are currently not built because they require
    # root access to build without patching.
    # Issue reported upstream here: https://github.com/Orc/discount/issues/266.
    # Add --shared to args when this is resolved.
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
      --pkg-config
    ]
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
