class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "a36685e1e4245107173b1a5e8abcd00cc65a475be330254a4647a3a953aeb4ce"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9297a111d9a93656ebd9b158a9f5dd531d12acbcea9ecc7083e7de3689744b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9297a111d9a93656ebd9b158a9f5dd531d12acbcea9ecc7083e7de3689744b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9297a111d9a93656ebd9b158a9f5dd531d12acbcea9ecc7083e7de3689744b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "777c7dcb702062066b477b2ae4218f44dbe7d6f5312161f4312cdb26aeb6fb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48064a8c7682e7f7babed738fca21dd5639f0dc1442eff97fb3a6ff80d0607cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
