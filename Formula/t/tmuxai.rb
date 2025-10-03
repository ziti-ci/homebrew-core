class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "bf8f27a8527e3de196392ee098029df3cb109d9eec56f4d9d69ff1ff23349416"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04bef56cdc97d84a09c2006b5c941ad15bba4e87a43bddfce6a518ca119a78ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b09a604e48cade9d253a488e41ed82a0e734478b14654a95314edd8dcf4c7ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b09a604e48cade9d253a488e41ed82a0e734478b14654a95314edd8dcf4c7ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b09a604e48cade9d253a488e41ed82a0e734478b14654a95314edd8dcf4c7ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d33c8b02837e8009107cd8d60ac177291d2ad78dae79f8c3b4db3ea28c3a81"
    sha256 cellar: :any_skip_relocation, ventura:       "f4d33c8b02837e8009107cd8d60ac177291d2ad78dae79f8c3b4db3ea28c3a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c53e1b8d863d90e44b67d62b910dce4d0e93c755897870df1b6bc5a38487f4"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
