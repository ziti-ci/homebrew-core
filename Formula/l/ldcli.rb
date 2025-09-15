class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "29d6735dc5c04cfa9d9c919d4ab5e81aa845b8ac9cddab51943de4c280d4f227"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cea470f79477f02aac2cf6e632144e566a7739e256e5d1dd0e9e4ce868ed6835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab670ad57c4f9744260e405808c7a91eda302f4932cd363f6a026c17f51df5e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7fa92e6388b9f6da6c30c187827782f79fe2b50fc997b549b91c01f195cc49"
    sha256 cellar: :any_skip_relocation, sonoma:        "41c97fe1fbcc928d6a7cfb01296d85fd23611315d98c0d4d858bf20cc517170f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16fa1e267ae2aa2bc0894ad2ac8e0a5f2d4e06ff24f7e2a39f27cea9fc26ce4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b460c3d725dcbcb75a5608c8b59f67faa88c61fa21dc99de6f90d315ae0b5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
