class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.23.0/bashunit"
  sha256 "7043c1818016f330ee12671a233f89906f0d373f3b2aa231a8c40123be5a222b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b491a85d3542b16bb380c27e1174493746e6c7666bd9b9c8c4f3d3eb36172f8"
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
