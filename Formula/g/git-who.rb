class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v1.2.tar.gz"
  sha256 "06c341ecbc81a518664b8facb49891fb94689da37c83978ee21a02916c0dbed3"
  license "MIT"
  head "https://github.com/sinclairtarget/git-who.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4639d20eb757e3b9665510d023ab6692e6f307fa3176c2b30fe027786e6d5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4639d20eb757e3b9665510d023ab6692e6f307fa3176c2b30fe027786e6d5fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4639d20eb757e3b9665510d023ab6692e6f307fa3176c2b30fe027786e6d5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2bb0c4a0e7c78a420cdf36dfe59d544df285fd80e57581d94d38eedd75b4d3"
    sha256 cellar: :any_skip_relocation, ventura:       "1c2bb0c4a0e7c78a420cdf36dfe59d544df285fd80e57581d94d38eedd75b4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be567b6ab0d7057ee00fbdca313574e4d21e3e587840a3d9ebf618ef494d5cf3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}/git-who tree")
  end
end
