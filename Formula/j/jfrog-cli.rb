class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.6.tar.gz"
  sha256 "8e65ea2ddfb7d33c63e977836b21228d85a9b01105c5d07e8efab6529a8c8fa6"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08a636705be89f3549960fb5f8187a4607848f06c285cb3fc6f29ca924ab1a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08a636705be89f3549960fb5f8187a4607848f06c285cb3fc6f29ca924ab1a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c08a636705be89f3549960fb5f8187a4607848f06c285cb3fc6f29ca924ab1a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0699d040c4875d4bd3406f53809821c539b2796be86cf7f419f20abc8fa8f8e3"
    sha256 cellar: :any_skip_relocation, ventura:       "4186ff0379cc3082d348bd6a951440b4cd376ba6bc15daef05370dede4caeb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3682d6f8873174978a551618ea75e8cd4c04c28bd74a8761cc376b7b89f3e24c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
