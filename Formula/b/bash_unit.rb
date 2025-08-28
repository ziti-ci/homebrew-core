class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/bash-unit/bash_unit"
  url "https://github.com/bash-unit/bash_unit/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "a2f76ddca88e2bef7c628c8cac6bf68b93a388fce143f6a4dc770fe1b3584307"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d5f3bacff684950c7a12a1ba1eb01c63368461d46994f9cfd4209150b73bc8d"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docs/man/man1/bash_unit.1"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bash_unit test.sh")
  end
end
