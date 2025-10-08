class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "4db3bcd0adbd379713eafba3992a4b371bf92d916403c79a960409012ff300c4"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286b737a3756f8a9c040941fcc9866b98676f30d472006aae84817d7f4b67efe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "286b737a3756f8a9c040941fcc9866b98676f30d472006aae84817d7f4b67efe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "286b737a3756f8a9c040941fcc9866b98676f30d472006aae84817d7f4b67efe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb495a5f6b39483c1d89e397bb864a2103ca3a9779d18e4957f260d6718d504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "897862081f40739c012b6752eb2ef58c5a7548c860baacddbcd1f51ec557541e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a455bb383dd1f665a19e4864d7ddeebfd981e846e1eeec238dfb77228f618c"
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
