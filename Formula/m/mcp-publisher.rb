class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "a216061ca6296d28fc54ac70d50e03919bcdde3e8f0f4731b9e8321decea3898"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f643d1b0baa8fc4083d0e1a8131a4732be4956d96ee895ccdf1343f6cd42b415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f643d1b0baa8fc4083d0e1a8131a4732be4956d96ee895ccdf1343f6cd42b415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f643d1b0baa8fc4083d0e1a8131a4732be4956d96ee895ccdf1343f6cd42b415"
    sha256 cellar: :any_skip_relocation, sonoma:        "827138042550d0b4a9b9a8a3a271c3bb391605ccc9c3bf388ccaa95e99a055e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f25003293f93cd20c24e20270d4f875c77881a4147ba42948f6a6a3547b59a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c04642f1b43c78dc1072389933469f20009963dc9bb226c488768b6b82ac52c"
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
