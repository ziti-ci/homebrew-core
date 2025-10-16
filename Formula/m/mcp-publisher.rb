class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "761d43c59ccc2eeafc55616bd0fe6d8e0916f108e93374a39c83a941c46f5414"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a5efc930c76047a6971dfff2838cc0711b4a0510635379a6e6803b6ec906717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a5efc930c76047a6971dfff2838cc0711b4a0510635379a6e6803b6ec906717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5efc930c76047a6971dfff2838cc0711b4a0510635379a6e6803b6ec906717"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbb6edcff339a0f4b09bcf70ee82e4fe7ae1988de4a4d434545f95d13fb580d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cf6cd7e7819098bb2a78d9e59bfb04c415119e03ccc0731b092ed8fea25e521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de75b2aac229a6f8626fdec5d455708a59fe70146e349f304a0cf83ad283772f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
