class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "a6bb4fdeea106ef3adb9a4aa1658829e681271f06700817e6382a101b7628ed1"
    sha256 cellar: :any,                 arm64_sequoia: "5442b8b312ae32f1f553fb978ccf09c63a8faec827d97d1c0ee6c25e6b8bec69"
    sha256 cellar: :any,                 arm64_sonoma:  "e34be5905def03dfd1a3b2e978175a2a20c04c9a707526437f747f290f72d575"
    sha256 cellar: :any,                 arm64_ventura: "0f477d1324b35e9d08f22bf9440d350dbef9eb7064a4a349dc61634037ccdc38"
    sha256 cellar: :any,                 sonoma:        "8621b8bd4592dbff5713e74fe7ba0e2df3e49ed586b11dd29f28c8cd3a716579"
    sha256 cellar: :any,                 ventura:       "0cbd0c1da955391882c5993e2c5ca0673b31aa9e96ccfa4735efe0bd179ec41d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfc26cd8e493d0423d00e49da1185a278aa84b79e3cd4325678fb161856607a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22cd5a684f506f67a27cb9bcd7c4a9192909ec3222ae9b87eacba18776f43c8"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfn-flip", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
        "Resources": {
          "Bucket": {
            "Type": "AWS::S3::Bucket",
            "Properties": {
              "BucketName": {
                "Ref": "AWS::StackName"
              }
            }
          }
        }
      }
    JSON

    expected = <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
          Properties:
            BucketName: !Ref 'AWS::StackName'
    YAML

    assert_match expected, shell_output("#{bin}/cfn-flip test.json")
  end
end
