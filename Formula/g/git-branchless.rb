class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  stable do
    url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "1eb8dbb85839c5b0d333e8c3f9011c3f725e0244bb92f4db918fce9d69851ff7"

    # patch to build with rust 1.89 and bump git2 to 0.20
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2d47380dce49c6b059369ff3378ab171c48f8fc3/git-branchless/0.10.0-build.patch"
      sha256 "7624b6fe14a4d471636e4b22433507b2454b7ee311eac13c4d128cb688be234c"
    end
  end

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3efab33fd1452f9b179eb701f2f0b3ad59b836245d6466172a5ce5bacd54bb78"
    sha256 cellar: :any,                 arm64_sonoma:  "f3713da56ed61e4ba98216df90e57bde5dba088d9d54cc48b396e42bda4e87b7"
    sha256 cellar: :any,                 arm64_ventura: "916640be323bdacc4fd0ad5ed2803cb1a4584d52ada450ae97b26b400c9abde6"
    sha256 cellar: :any,                 sonoma:        "17d8fa92649b7b75f85551251c4bdea543489247b14292b31f02696aea408222"
    sha256 cellar: :any,                 ventura:       "ae5923a733959106c2f4de98cf3c069d736af1f644991abb4355ab2bb72d12df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1910e0339bf1ef3e04848b49becde5b03556c1e2c6c511f47c998f8ba7efa9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246ff33a6a9007356ee52818e9ac3697cec0d8b8a173987870a9a0b7577b1b4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
