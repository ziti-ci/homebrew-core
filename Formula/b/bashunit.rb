class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.22.2/bashunit"
  sha256 "b52b602de0f1d345cc99b07506840d6beaa5c64d1e631e7243866d7e3273f439"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae9d53654cb23bb342850c19510e680ec765d417767a9113fc011d6993e0e409"
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
