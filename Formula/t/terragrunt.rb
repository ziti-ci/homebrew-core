class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.88.0.tar.gz"
  sha256 "0ee08b062f3f7d3c5a9144f46b056a5b8f17803663c1d7864c2a31978645bae3"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88047cc17f6eb456e72e3a920b4d66fd5dbb03afb74056ea1896748306a31aca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88047cc17f6eb456e72e3a920b4d66fd5dbb03afb74056ea1896748306a31aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88047cc17f6eb456e72e3a920b4d66fd5dbb03afb74056ea1896748306a31aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "15dfc93e04edf44dd2282a2d288c09f5e597db9e59dcb29784e48f11610cd184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2c36dd249329716c40b3643d93a42a9c4b34ee87d13e4d22db77d4661f6511"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
