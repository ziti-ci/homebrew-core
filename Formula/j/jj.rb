class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "1b8f6bdbcf8e53d6d873c8677154fe8e3f491e67b07b408c0c7418cc37ab39ee"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499242ea9c88e299d1fcd4e47a30e142cec49f03a8b22eb05e482bbb95fe66b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e151245bfebaa3018ec7cbd6332726007984412690afe26e71a18e8afbd944e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "055df210752d0fb37b3dfac6602f41fcf5d0cbde55368077c338b85598585d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "471e2dd0f97794565495af40929618bcbb57967d1eb75963a5f5b19fac170976"
    sha256 cellar: :any_skip_relocation, ventura:       "005ee9c7e91b7168f27bd5924932805f579107c1bd7edd5541ff1d56391192d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dedbab1683b4c4351d05d943b7b7e9f24c3006f467039282a7555da65061eb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe730371688479bab330af0d03fc04bbc122fd0314bf413cc58b4d15f2b43181"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
