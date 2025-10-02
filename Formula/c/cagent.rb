class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b7165b82f18b1c8e7ebb5415e8e62945086c8849c415d9f134fd85125491da82"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5050ebbf4b21196d6680c01fe213b0d23c0b5705ee40d3858ae858b3369d209a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5050ebbf4b21196d6680c01fe213b0d23c0b5705ee40d3858ae858b3369d209a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5050ebbf4b21196d6680c01fe213b0d23c0b5705ee40d3858ae858b3369d209a"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a1614f3c0dc75258cedc7429faf12688f6617f4184d58ce330da0e0839074e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9f6d0e81980fb74c998215c9a83fe63344a3cabf0439218e3b7150bb9ea4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4187e4b74f182f0143925ed3e9a8decd9a29d37a39cb17bce1bf04bd4d77d302"
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
