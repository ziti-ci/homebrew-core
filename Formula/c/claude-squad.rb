class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "01155ad6a3e6f955402ae744683cfc5f22f2bb29e8f5b70e6d14e98dde36e9df"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341da81f5073727c0ef8877f9e932db5da508284492b459d195ba357d7731b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341da81f5073727c0ef8877f9e932db5da508284492b459d195ba357d7731b49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "341da81f5073727c0ef8877f9e932db5da508284492b459d195ba357d7731b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1a38a92529ba991346d51510d6dd59ec9acc877b3725374ef235a7cdf52a834"
    sha256 cellar: :any_skip_relocation, ventura:       "d1a38a92529ba991346d51510d6dd59ec9acc877b3725374ef235a7cdf52a834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f35f1b7280b0461d0d81d3e615d069a70b5ecbd940cbbaeaa91bb51a4fb9c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", "completion")
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
