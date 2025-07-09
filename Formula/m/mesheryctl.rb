class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.116",
      revision: "a6ff2390f8e098662857039cd380d85c788c91ea"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3658f09e7a61f03021ad147e54d05bccbbe7340238d8af934aa276a492831941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3658f09e7a61f03021ad147e54d05bccbbe7340238d8af934aa276a492831941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3658f09e7a61f03021ad147e54d05bccbbe7340238d8af934aa276a492831941"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7661ee47ebdfc790fe6e2860037240ecaedfb9f1a1a75d0f3c5b1d98e30ff5a"
    sha256 cellar: :any_skip_relocation, ventura:       "b7661ee47ebdfc790fe6e2860037240ecaedfb9f1a1a75d0f3c5b1d98e30ff5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de48d9673256b1576da427a119b0f0fef0e7c4c58a8de531cee8cc809fe15642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbde0bd127764e9b494a4f2432a8c423519f90808db5b03e7e4a21dc9238239"
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
