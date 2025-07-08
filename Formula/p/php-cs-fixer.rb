class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.82.2/php-cs-fixer.phar"
  sha256 "4027224dd6a19a291da22e263d0d251cca069e3b3c471d3f80983a68579619eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efafefb2af2242c43345462b7e5d868184ac6f2aba64d2cf5307a05425e394d0"
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
