class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.25/phpstan.phar"
  sha256 "77aa32604d0459935922faefcd206322e03dc46b338cfc4be7f50bcfb963dee2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690d9ec29b0189eab24047a41ce88d2c786dfc54892296744f28917a639f22dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "690d9ec29b0189eab24047a41ce88d2c786dfc54892296744f28917a639f22dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcbf1753c0004ef1c98f5bb6fa644a4f0efcb23a3e91d58ed66e000532f2afd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbf1753c0004ef1c98f5bb6fa644a4f0efcb23a3e91d58ed66e000532f2afd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbf1753c0004ef1c98f5bb6fa644a4f0efcb23a3e91d58ed66e000532f2afd6"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~PHP
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    PHP

    (testpath/"src/Email.php").write <<~PHP
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
