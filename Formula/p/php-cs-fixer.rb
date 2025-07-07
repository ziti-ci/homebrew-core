class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.4 on the next release, if possible.
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.81.0/php-cs-fixer.phar"
  sha256 "b5c47609719b2a84c2c1c3898ef457ba8e5bedbf6820a73e1e216a076f6cf4fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e6c8070b455efcb21e6717d56517ab2226da43606bdd075e0cd53efeeb99e30"
  end

  depends_on "php@8.3" # php 8.4 support milestone, https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/milestone/173

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php@8.3"].opt_bin}/php
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
