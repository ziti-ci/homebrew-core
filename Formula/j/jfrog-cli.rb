class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.8.tar.gz"
  sha256 "ce121daa69a813410049d9bf00bda81e8a8881ef87ac15210831977475a637cd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acec14a921314725cea3d970aebfe1478477edc5c91186b9ed585b080de022cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acec14a921314725cea3d970aebfe1478477edc5c91186b9ed585b080de022cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acec14a921314725cea3d970aebfe1478477edc5c91186b9ed585b080de022cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ada7a45e88a7a1901e975b9f93a675e104ef85853d96ca1d18d729f55c63cc1"
    sha256 cellar: :any_skip_relocation, ventura:       "74b2976fbfb1087b3f76dedff31bc8a7eecf14883abdab50cbe2c3f991aa47c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac136507cd4a192397cc7668f0557dfd89589785f4d2f2c386915e33b64fd5f5"
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
