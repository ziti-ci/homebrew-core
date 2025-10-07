class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.89.1.tar.gz"
  sha256 "1599380eec0e46a652a36ff8986602574ce780be1f1e8dbe85e6a8d99f20bfce"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7756a2ce66a6b4338309c8bd9d8d5042b1fdb95ffb915ff6ff3f3a707175e60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7756a2ce66a6b4338309c8bd9d8d5042b1fdb95ffb915ff6ff3f3a707175e60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7756a2ce66a6b4338309c8bd9d8d5042b1fdb95ffb915ff6ff3f3a707175e60e"
    sha256 cellar: :any_skip_relocation, sonoma:        "27eb5cb46cbe05b23f11f99f38fd9dbc5a5c409a5cdd3332b91175416d544874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd3fbfee00db2fec0ea8e01915ca22a63afa8755dd296c75d161a6b3231de65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07134258f92317d0a4609bdf1eaf25df8c38f642ad5e8f5a03bae3771411b0c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
