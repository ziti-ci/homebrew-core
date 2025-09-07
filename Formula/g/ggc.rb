class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "b2eb14ed42e47269c1081ac12d5da46d8c4868851a1e82a7b77929ef5df367ce"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33bc4b42cca49a8906f552f7334c6c15d01e3e1c4e16e2cc26cf685d8d37f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f33bc4b42cca49a8906f552f7334c6c15d01e3e1c4e16e2cc26cf685d8d37f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f33bc4b42cca49a8906f552f7334c6c15d01e3e1c4e16e2cc26cf685d8d37f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "4819b0997292397b4ef204be3f330e0fb53ea8529013a33c870ddfc7dc56b670"
    sha256 cellar: :any_skip_relocation, ventura:       "4819b0997292397b4ef204be3f330e0fb53ea8529013a33c870ddfc7dc56b670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2efab15ad43dfa054f9cbcefc33c5bf10d34023cba2f4e866533ebf56845f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9bed606692365bd56f523d0653a45b34a87adb4aadbe33876eb64a053b88a1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
