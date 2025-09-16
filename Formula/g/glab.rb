class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.71.1",
    revision: "cd76122bc4a178933c523123979aabbcd726a9bf"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f66abed8d60bfa93aef5d5571c9fb822e706caf6138244f6a30044dd44ab242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f66abed8d60bfa93aef5d5571c9fb822e706caf6138244f6a30044dd44ab242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f66abed8d60bfa93aef5d5571c9fb822e706caf6138244f6a30044dd44ab242"
    sha256 cellar: :any_skip_relocation, sonoma:        "69f417c2c3b7e9aecd394fb87df3266c60dde01c8b5c2fdddd4ce6571cef1249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042ccf8dc7170ace107e9c9a0805296c57cf17070d47966a0528490b1d1789ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7815081926ab8621b753734c3cf105b003834603a12dc39122a853a0b841046f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
