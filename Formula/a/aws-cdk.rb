class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1023.0.tgz"
  sha256 "190a2a3e616432d7cc9d03a44dd35ba871ebb32350da51cd01a9fdaf71e65fb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c49fb78ee80198d1e029c4f17f013e95e425e47cb4f53acc2a12519839e9bf70"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
