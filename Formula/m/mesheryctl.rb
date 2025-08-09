class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.128",
      revision: "1e4a66205585a26c33813f16650c945ac9503f55"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8411bb402898e6b1c3067b36a4a107509d14530b2c0f82ccf7c491e59d7d1aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8411bb402898e6b1c3067b36a4a107509d14530b2c0f82ccf7c491e59d7d1aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8411bb402898e6b1c3067b36a4a107509d14530b2c0f82ccf7c491e59d7d1aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e516317f8876001bbe4c227ef38571770da93f795a87f1f84516c0b763e5c2a8"
    sha256 cellar: :any_skip_relocation, ventura:       "e516317f8876001bbe4c227ef38571770da93f795a87f1f84516c0b763e5c2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d1b755518a3bc339ff052146d58af2924b6f23e9513e491fe857f69495f2746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fac7fadd23a2907601ab9966027b6d3af841f78eb8b521506406aaf1e7e2803"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
