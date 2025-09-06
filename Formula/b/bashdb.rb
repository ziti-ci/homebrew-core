class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/5.2-1.2.0/bashdb-5.2-1.2.0.tar.bz2"
  version "5.2-1.2.0"
  sha256 "96fe0c8ffc12bc478c9dc41bb349ae85135da71b692069b8b7f62b27967ce534"
  license "GPL-2.0-or-later"

  # We check the "bashdb" directory page because the bashdb project contains
  # various software and bashdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/bashdb/"
    regex(%r{href=(?:["']|.*?bashdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f2ec4abf07b97ccf17dd28f503864ff00ea05049a9b844de637612b85478aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f2ec4abf07b97ccf17dd28f503864ff00ea05049a9b844de637612b85478aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f2ec4abf07b97ccf17dd28f503864ff00ea05049a9b844de637612b85478aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a66264c4831ecc61cf6ea6fbebfa335cf2152742017132ca9309068a0870b8ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a66264c4831ecc61cf6ea6fbebfa335cf2152742017132ca9309068a0870b8ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3880ed9494d5dbe3a1dbebf971e66fbdf4edabdad128cc44ece337d906c28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2ec4abf07b97ccf17dd28f503864ff00ea05049a9b844de637612b85478aa7"
  end

  depends_on "bash"

  def install
    # Update configure to support Bash 5.3 by replacing `'5.2' | '5.0' | '5.1'`
    inreplace "configure", /(?:'5\.\d+'(?:\s+\|\s+)?)+/, "'#{Formula["bash"].version.major_minor}'"

    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end
