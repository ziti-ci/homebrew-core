class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "7e9d47d8025f1569c0a53c6030602e6eb049818d25c5fd0cad777efd21eeca20"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b506403ad1d7da51685259f4ad23b3b0c14b8bfb070608491bbb219e916b512d"
    sha256 cellar: :any_skip_relocation, ventura:       "b506403ad1d7da51685259f4ad23b3b0c14b8bfb070608491bbb219e916b512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f702035fa2d158f94eeec851b805a10e0ec75289cacd5da67fb641202c5a14"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
