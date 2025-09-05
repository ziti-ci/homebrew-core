class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "f0d6ebf7cc9a3bae6ef9f386a4fbc55586275dde13b7c8a87a7d84eead4c69ab"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "30bcaf57f2cc40306b287721fab517cd86a13037d7d011586e6e74d6e326942d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d0bd3ff9ffd907f877e58389e54a8fea163d460dc96ae20978940e9d09a18e6"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v2/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"

    generate_completions_from_executable(bin/"nerdctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
