class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "d59a4f25c2ad4478699585aff16d3b99b9b1fddfb894bdf072705d6342aee59a"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2564fe8ff7366d62ae106fa1f722bcb723af6c3e71fad0c3a85ba4c0af05eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2564fe8ff7366d62ae106fa1f722bcb723af6c3e71fad0c3a85ba4c0af05eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2564fe8ff7366d62ae106fa1f722bcb723af6c3e71fad0c3a85ba4c0af05eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2104985e0cde1ff6d0ff529729ead445c8770157f88741a362b86c5fba59a3fa"
    sha256 cellar: :any_skip_relocation, ventura:       "2104985e0cde1ff6d0ff529729ead445c8770157f88741a362b86c5fba59a3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2b1afb58f0441c4537b18771b73a534ca7a3ce1c3bccc5e647987faa6ff25e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
