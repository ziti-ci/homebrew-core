class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.tar.gz"
  sha256 "17c945bdf7d240f6419eff7cf02ed481c722904e2eaae927900908e50dc4d4bc"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d86ac180085943a1999254fd90b4b5a4dc94fef2b385cad713258e2d1bbed5"
    sha256 cellar: :any_skip_relocation, ventura:       "96d86ac180085943a1999254fd90b4b5a4dc94fef2b385cad713258e2d1bbed5"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"

    pkgshare.install "examples/alb-ec2.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsdac --version")

    cp pkgshare/"alb-ec2.yaml", testpath/"test.yaml"
    expected = "[Completed] AWS infrastructure diagram generated: output.png"
    assert_equal expected, shell_output("#{bin}/awsdac test.yaml").strip
  end
end
