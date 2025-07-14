class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.83.0/php-cs-fixer.phar"
  sha256 "8b0e129c835b1bb285d33dfe1b134eda7d75eb4b074bb21df2e68307f0d422cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b587a3c425b73ab4799ea38eb372ed5b6b8f221429b18c9b113f5d6366f35554"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
