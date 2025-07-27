class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.22.3/bashunit"
  sha256 "efae498584b4f11cd05e4acbba586009e391259fdbfac391844b75b7552e00d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c87a7c7be91e487bf9815959190d65251650460a03bc720ed1fdd4c9069d2ee"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
