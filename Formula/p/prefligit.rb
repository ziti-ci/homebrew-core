class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "6a920b6d7913d36085624c1f211024c62815dce8939a2f20882ee36dcd47d8e2"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcca90003e9a38e093eee4c81805028a8633353468734dd01b4db359224b27a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20eeabbc86551835e3e3fc3f7c11c64e909575c078bffee2090c79efffeee1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23b4736cce412dab8e0bd3e75258447879c182edebaad71108c649bbbc4815a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "08eb28b0a87bdcff159f363097a2073b43a4fadeaee03a6a0771ab6344863ed2"
    sha256 cellar: :any_skip_relocation, ventura:       "5b9da4c1fb7010cee628ebd3308cf891b68fdfaf195cd9c46282cd9d23d367ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1dad0c0c72f06a758ff15623c869831f06494e1b64246a4eb371cc89c75637a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765d421b4d5f0c0e4f3953af6597f01b1548ad284d0003ebe9f91f450dea75de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
