class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "3bf030af7821ba762ac1321ffdf8e401928e1f7a9dff15be42abba62410006a6"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d794e083bebf7fe59bb2a1cea5c50f2625fba075811333d8a46e61f60f58618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d794e083bebf7fe59bb2a1cea5c50f2625fba075811333d8a46e61f60f58618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d794e083bebf7fe59bb2a1cea5c50f2625fba075811333d8a46e61f60f58618"
    sha256 cellar: :any_skip_relocation, sonoma:        "69241d95d94372fb8f444c2abb4eba6a49f6e676534aa080950c6e65a90fad6c"
    sha256 cellar: :any_skip_relocation, ventura:       "69241d95d94372fb8f444c2abb4eba6a49f6e676534aa080950c6e65a90fad6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c9f62661d1c367a79aeb24794cff4fb899a9d2c7421a45b446e2b63ed8d7b9"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
