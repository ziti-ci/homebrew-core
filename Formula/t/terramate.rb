class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "b5886254f5dea92808da89b27206c24ca67a5d28b4b9c4cc5934f0792b170d7a"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b402ecdab678a0150cb3630823530c1085901ea6e5b7179b1e5e4d63372c3af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b402ecdab678a0150cb3630823530c1085901ea6e5b7179b1e5e4d63372c3af7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b402ecdab678a0150cb3630823530c1085901ea6e5b7179b1e5e4d63372c3af7"
    sha256 cellar: :any_skip_relocation, sonoma:        "227cdb8ef04b4b9b58067247de392fbf50ba80abe7b79ea9f898f028264b3a5d"
    sha256 cellar: :any_skip_relocation, ventura:       "227cdb8ef04b4b9b58067247de392fbf50ba80abe7b79ea9f898f028264b3a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c45c8eed1a3334e4f49f5e611844212a6ebba723033042591159ef225f1169c"
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
