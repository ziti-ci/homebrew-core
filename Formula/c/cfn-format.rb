class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "37fb974ee0eb36ceb80f38f13141883f3779a81c79562d0ad15afcd74753485e"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb031518510da595fc6b288c746f5bdd0a596165263ec1a31fc6d6c32af06e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb031518510da595fc6b288c746f5bdd0a596165263ec1a31fc6d6c32af06e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb031518510da595fc6b288c746f5bdd0a596165263ec1a31fc6d6c32af06e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb0a1b65f14bde6c80049d1199e42595cc7048a2d0c56952c157ece444ec2ee"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb0a1b65f14bde6c80049d1199e42595cc7048a2d0c56952c157ece444ec2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef702e496fa4266fa1128612eb4ba705fb92dee528462993a9fcf9d044cb603e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cfn-format"
  end

  test do
    (testpath/"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
