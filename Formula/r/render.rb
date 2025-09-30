class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d261865647708509e8bd32a99e3ef4cda635b38c39f23665b0f62d6a3bb81f43"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8983bbf98e5fabb3adb5265a8fe22d5d1bc75d290d6b65bd17eb0b488f2d2e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8983bbf98e5fabb3adb5265a8fe22d5d1bc75d290d6b65bd17eb0b488f2d2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8983bbf98e5fabb3adb5265a8fe22d5d1bc75d290d6b65bd17eb0b488f2d2e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69be8f38dece0ad0ce0424873e31815152c330561ac7713ecdb1b1024756e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcdbe0dc58bf49aef7a0d86b8c2bb9e0e6aeb58d2fa1a1664fe9b2315fff7d77"
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
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
