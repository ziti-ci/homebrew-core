class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.15",
      revision: "72ea1d48513a467ccdbff8e238396a278c3f4dd6"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "075030cc5470969760f925c56234ac252c828384d21b566bc865b11dee1dad8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4540f91ce3f0c7ba446f7e696e74b0637260a9bd7423c242488010826c9953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5935b9c323250ea386788e60a68f991502a196e4eb482c37006ff81585e0b0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaf7b3c7a6cde791004c04a55058b6e2b99d4ae1da274e6f20b674be265a597d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bc46e81223b4cf3a2fe5b2788adbd0cc7a2e8046e9f31f65325cc7cc165e9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635208f6ec7b1076d0794ae22082dfc8f9742e8e4b40d3ac3058fba5839e8c60"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
