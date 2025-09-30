class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "77695fb030656ac2bc18bd5ad3d600c7c5ec27a4cdf8a5aecfeec0a1a304c684"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65d6bfc284ae7a484dbe511f4ff0df2d04eb84bbf768de34b592c4246b0d43c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65d6bfc284ae7a484dbe511f4ff0df2d04eb84bbf768de34b592c4246b0d43c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d6bfc284ae7a484dbe511f4ff0df2d04eb84bbf768de34b592c4246b0d43c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e802b3149f966f99f905f5644fae37ceabb7c2e8a3c24cf4d07bb636bb6657e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf01a889fb53632ca1956ba7821cb33d863c07bf161c0a356c439b12028603d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61962de27dfe8bc18f72bb31e0360740b77ced7b784f8e61ac9fcb9cdcebf22e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
