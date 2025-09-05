class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "04d43027db9bdbf86c5f8bdf6c7624d6381b0cea26ec4042ccd5e9b063e3d9d2"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81cb7bbf0a609c2f694c2d2e4f1d7d248a35288fe8a90a48ff70f42231d05ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81cb7bbf0a609c2f694c2d2e4f1d7d248a35288fe8a90a48ff70f42231d05ff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81cb7bbf0a609c2f694c2d2e4f1d7d248a35288fe8a90a48ff70f42231d05ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f5f8933d8ffb1ff1b855a9cc769051ada8e142688466b3d82ea834634d5cef"
    sha256 cellar: :any_skip_relocation, ventura:       "b5f5f8933d8ffb1ff1b855a9cc769051ada8e142688466b3d82ea834634d5cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e58c7a8e2958188a8eee80e7943c0050099dd1d24ddbc0e677a38718b62c5f"
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
