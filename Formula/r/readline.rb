class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.3.tar.gz"
  version "8.3.1"
  sha256 "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc"
  license "GPL-3.0-or-later"

  # Add new patches using this format:
  #
  # patch_checksum_pairs = %w[
  #   001 <checksum for <major>.<minor>.1>
  #   002 <checksum for <major>.<minor>.2>
  #   ...
  # ]

  patch_checksum_pairs = %w[
    001 21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de
  ]

  patch_checksum_pairs.each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.3-patches/readline83-#{p}"
      sha256 checksum
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url :stable
    regex(/href=.*?readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(readline[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(
        "https://ftp.gnu.org/gnu/readline/#{patches_directory[1]}",
      )
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?readline[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2b2a7b035021c228b2e5dc392a0764174c0efb3dbb673fd06ee1b7a8eaa2cc25"
    sha256 cellar: :any,                 arm64_sonoma:  "5f5c9d9954dbd01bd160080f9a40f09146e72ffee718c6c1d2807125c6ef8c9f"
    sha256 cellar: :any,                 arm64_ventura: "360d6bdde7b80fad0d8b0c14c4ddf2eb067d30699cd738bc44b9ca6c6ec34eb0"
    sha256 cellar: :any,                 sequoia:       "c1a8c74eb55d439ab7fac968f13e01e7f46983dbaaa8366b564302132788443e"
    sha256 cellar: :any,                 sonoma:        "901f1230403f81ce7436db17c2cff1b8856fee17353635ba016774a4389b4d46"
    sha256 cellar: :any,                 ventura:       "93522b52a1220c62fb1aba282b60e2820b4118e56fbe9812fe51c3cdc7def4f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7252c80cfdf7f67036cdbea02915b8fd8f6a4a4c3af5564e9cbdb4de643135d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10dd3fcccedba84bb3392ce97dc50b28ea73ce83707d48ac73b9e35b326d9cea"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-curses"
    # FIXME: Setting `SHLIB_LIBS` should not be needed, but, on Linux,
    #        many dependents expect readline to link with ncurses and
    #        are broken without it. Readline should be agnostic about
    #        the terminfo library on Linux.
    system "make", "install", "SHLIB_LIBS=-lcurses"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    C

    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end
