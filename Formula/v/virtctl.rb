class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "be69c1d91c4534e0391f4101f2eedc4dc6c0b30569d9d60a6569033f5edd8465"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd698dd310a1879eb2f0830d5724ebe59d3cff4240c692cb929d9e0eb7d6c048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd698dd310a1879eb2f0830d5724ebe59d3cff4240c692cb929d9e0eb7d6c048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd698dd310a1879eb2f0830d5724ebe59d3cff4240c692cb929d9e0eb7d6c048"
    sha256 cellar: :any_skip_relocation, sonoma:        "7abee3e56163c334f624c69b59584060b45cfff6f0c45727ee93dc42bf239795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9463f7836c75cd32bbd2e08c1a8962ce0fdd9a0040b9af806ae68bc69658129"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
