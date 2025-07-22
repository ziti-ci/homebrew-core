class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.22.1/bashunit"
  sha256 "7706f5987e3dc6868694ed3c38b0b085a02d1404c01f31c21c923ec8e7d4bc55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbb68a7ec9020a439d40e5e9dd004213cf74b443c712b424dabf8964484995f8"
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
