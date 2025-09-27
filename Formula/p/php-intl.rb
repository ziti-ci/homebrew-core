class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.4.13.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.13.tar.xz"
  sha256 "b4f27adf30bcf262eacf93c78250dd811980f20f3b90d79a3dc11248681842df"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5cb70e61c1835532f99a01170482bb97067e18d18494fe6cfa32608cc12554f"
    sha256 cellar: :any,                 arm64_sequoia: "60de5be854ae23ac77b6495361d9a3a4c1f4e16685dee3cd53a7839311c26e10"
    sha256 cellar: :any,                 arm64_sonoma:  "a3bd8a31456bba69803e1e2ef6472cf9b667a1ed203a610336032c33b2f50747"
    sha256 cellar: :any,                 sonoma:        "ada2842427a29ab72bad76206c2343949686771ea3135142960e9f0c378bddf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84149fbe44505b5c7dc97cc1afc749fa99ed29e1d49731e9e36181dc36c4b9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d390e9bf67059c4a7b5c99ee0917d0544568ea97923065c12d519ae42d2493"
  end

  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "php"

  def php
    # Always use matching PHP version
    Formula[name.sub("-intl", "")]
  end

  def install
    # Keep aligned with PHP formula
    extension_dir = Utils.safe_popen_read(php.bin/"php-config", "--extension-dir").chomp
    extension_dir = lib/"php/pecl"/File.basename(extension_dir)

    cd "ext/intl" do
      system "phpize"
      system "./configure"
      system "make"
      system "make", "install", "EXTENSION_DIR=#{extension_dir}"
    end
    rm(%w[NEWS README.md])

    # Automatically load extension on install and unload on uninstall or unlink
    (prefix/"etc/php/#{version.major_minor}/conf.d/ext-intl.ini").write <<~INI
      [intl]
      extension="#{extension_dir}/intl.so"
    INI
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php
      $formatter = new NumberFormatter('en_US', NumberFormatter::DECIMAL);
      echo $formatter->format(1234567), PHP_EOL;

      $formatter = new MessageFormatter('de_DE', '{0,number,#,###.##} MB');
      echo $formatter->format([12345.6789]);
      ?>
    PHP
    assert_equal "1,234,567\n12.345,68 MB", shell_output("#{php.bin}/php test.php")
    assert_match "intl", shell_output("#{php.bin}/php -m")
  end
end
