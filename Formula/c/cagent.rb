class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "e404cb546c6db2ab6f96d792b66b0588b9c6396d18f211366bc57f64182ce627"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a62c22a6b380a3213602fd09238039a354e0ff40ca0ce0de77eba7790fd29954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a62c22a6b380a3213602fd09238039a354e0ff40ca0ce0de77eba7790fd29954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a62c22a6b380a3213602fd09238039a354e0ff40ca0ce0de77eba7790fd29954"
    sha256 cellar: :any_skip_relocation, sonoma:        "91fa206254c3186644b7ba751d605b130824ca4b38be450e76c3eb994893a9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56dab8cc49c950f73727fb1abaa14dfb36d8e9d3bf0b907209741a5bb2816ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc50f4a5945ba2fe2a5ce123dbe3c4c19346a779cc75180183a0f6d78f3a4ad"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
