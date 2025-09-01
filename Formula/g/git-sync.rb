class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "38c7dfef256d5321e57e46ea94a245aadc963e50f0e3231b3ce710095b81d7ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "00358f17adf3bb83339129bef02f7031c9e1c2a64f043148baf0e329ebe1d6e5"
    sha256 cellar: :any_skip_relocation, ventura:       "00358f17adf3bb83339129bef02f7031c9e1c2a64f043148baf0e329ebe1d6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2802fa19c03b602a9988b64d7339d1046a03548359fd9f92f17f5247912f3d1a"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
