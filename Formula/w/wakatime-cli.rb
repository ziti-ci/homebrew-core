class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.130.1",
      revision: "a7da4de82edc4d17dfe0d78704ce7d414462db27"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1af00418abca6297fd4551eb97788208e0fe987664550e5141cd2b26fdabd949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1af00418abca6297fd4551eb97788208e0fe987664550e5141cd2b26fdabd949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1af00418abca6297fd4551eb97788208e0fe987664550e5141cd2b26fdabd949"
    sha256 cellar: :any_skip_relocation, sonoma:        "b917921eca84263830e92543eb6e8d8c2e590855aea29a02b5aa2ff8bc736a14"
    sha256 cellar: :any_skip_relocation, ventura:       "b917921eca84263830e92543eb6e8d8c2e590855aea29a02b5aa2ff8bc736a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f652b121a10845a145cb6270a6e29f41fa16372a8a91decfe060f34bfc0a19"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
