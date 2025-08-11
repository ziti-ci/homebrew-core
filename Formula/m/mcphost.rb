class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "30c0f00b721d4ff16bae15e4c210effa7a4caf035b43a348769d2997d0b9b143"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e62fc1572ca153e17f3b08b556f858dae8587bcd64ffdb8a6ddfc6dc17dcef"
    sha256 cellar: :any_skip_relocation, ventura:       "51e62fc1572ca153e17f3b08b556f858dae8587bcd64ffdb8a6ddfc6dc17dcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bddd85ef20dfc81f90cc5955d4d0ddc0c2f81064270b06b7db98acb2bf4572"
  end

  depends_on "go" => :build

  # fix version patch, upstream pr ref, https://github.com/mark3labs/mcphost/pull/128
  patch do
    url "https://github.com/mark3labs/mcphost/commit/008a4991ecd20b27866f458e492715c3dace2ddf.patch?full_index=1"
    sha256 "82cd1e1cfc4eebbc0ed4114a3b93e6306be73243eb0e48aa7e4c7d648070ed8f"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
