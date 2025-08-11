class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.4.2.tar.gz"
  sha256 "428b388f0adb765b5cb4cbb4e9c5d210fe83d1e82c241ac9b076b4bbd5bdde99"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b414a1dbf437026ea72097e8e1d2c6e0b477eebaf57f0f7744df351e7eafe63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b414a1dbf437026ea72097e8e1d2c6e0b477eebaf57f0f7744df351e7eafe63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b414a1dbf437026ea72097e8e1d2c6e0b477eebaf57f0f7744df351e7eafe63"
    sha256 cellar: :any_skip_relocation, sonoma:        "834bc1fcc4cdc35f9ef9bd08c878346fc5d4432a9f2d9aa7827334d4e20e6178"
    sha256 cellar: :any_skip_relocation, ventura:       "834bc1fcc4cdc35f9ef9bd08c878346fc5d4432a9f2d9aa7827334d4e20e6178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02a7cfcbf2a706f70bbb10177eb4441d95b660f06373d3dccffa939ede2e591"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
