class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6c03f69652f5bd5e8e7adb3d20f987cbf84b33dd7a9a056cd6c8787f658d63dd"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab409bbfe8a5179bfa089534324fb6a5f388e3f9912a5262563ec253376b212e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab409bbfe8a5179bfa089534324fb6a5f388e3f9912a5262563ec253376b212e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab409bbfe8a5179bfa089534324fb6a5f388e3f9912a5262563ec253376b212e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f01cd063d3df17425d6541d451f6f964c4c4c33938749796357204252dded0"
    sha256 cellar: :any_skip_relocation, ventura:       "33f01cd063d3df17425d6541d451f6f964c4c4c33938749796357204252dded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eede78cefe5d245fd30ba34ee36c77bff79509ee17dbf18fd0fdc728d7bb5ae9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
