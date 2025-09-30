class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "acf647ac56ac48033213eb192cceee2ca330513f81667a879c2da1ecf03e0145"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad634999123ee981c6ca8ce3a7b2e326e008fa1f024bc297b542accd403aabe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad634999123ee981c6ca8ce3a7b2e326e008fa1f024bc297b542accd403aabe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad634999123ee981c6ca8ce3a7b2e326e008fa1f024bc297b542accd403aabe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8badcc2deed106cda56178f9bc54b6d98b83f3d4646470af5a655d698c78639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159507f051f65e4d3aafab4b74963330a07116883cf9ba8efd08bda081b80ae1"
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
