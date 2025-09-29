class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.88.1.tar.gz"
  sha256 "f47db272bce451160fbd524f0645020b0faf66849084cf3531800474f36098dd"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "740b866bb4a9f8d6f900f0fe8d46324cb8ae81dd20a1dad1c892f87d88b0fafb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740b866bb4a9f8d6f900f0fe8d46324cb8ae81dd20a1dad1c892f87d88b0fafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "740b866bb4a9f8d6f900f0fe8d46324cb8ae81dd20a1dad1c892f87d88b0fafb"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d2361d4b49c29ba894c4c05497971b28f149f810d8ba80c63302ced14f8435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f115a17e55590d8614a34493a982caf8733c6a11fc06ff79c12f336e5b1da6"
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
