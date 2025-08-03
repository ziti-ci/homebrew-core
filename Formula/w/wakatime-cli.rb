class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.129.0",
      revision: "f56a0caa88ab3d3a3c22cc77e9954ca910d54869"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff760948960ffce768cc4033e76bcb33b72bd1d4beac39d9600ddaabc8f3f5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff760948960ffce768cc4033e76bcb33b72bd1d4beac39d9600ddaabc8f3f5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff760948960ffce768cc4033e76bcb33b72bd1d4beac39d9600ddaabc8f3f5ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "98947b09da07d0dc4cb968329b1c6ccbbc75a3a4238a9540c22a9b0e69618d63"
    sha256 cellar: :any_skip_relocation, ventura:       "98947b09da07d0dc4cb968329b1c6ccbbc75a3a4238a9540c22a9b0e69618d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f121ff3400960d7a8dc38ed5777afa08f5d48da9951f3d2e240b32190ab0fd"
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
