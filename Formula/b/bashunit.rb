class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.25.0/bashunit"
  sha256 "baebbebf93a515f516598b14d5c42d02f4c5bc9933a4c1f59eca36122e109f2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e89795511f40c43471578bfdaed846149b7f5662401ba12cae40839c4ee1119"
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
