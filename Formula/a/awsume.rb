class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/d7/08/264d5c0b1a2618c95f3a391e038830c18bcccce5f202b293acdb14b7ac63/awsume-4.5.4.tar.gz"
  sha256 "4c1f6336e1f9e36b2144761345967f50f43128363892cc62325577201e133b1b"
  license "MIT"
  revision 2
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a121ce0844270e2aa7e5f32a874ceab87948d05968a229d076feceb5d1c2681"
    sha256 cellar: :any,                 arm64_sequoia: "030e2f49997fed0235ca111b48944bd6f855eaa2d2c59cabd9ba247e22e5ef7c"
    sha256 cellar: :any,                 arm64_sonoma:  "2ecc4d5fd1c6db43db69f746d3f6f1a9da807eda6514bb3c2769977ae2d9fb1b"
    sha256 cellar: :any,                 arm64_ventura: "c85b9414c5695f72832ac4256ccf1b84b9bb6346b2956d7103a6c00307d4a036"
    sha256 cellar: :any,                 sonoma:        "57080492ae76c7fc09457d829fb89b8f3e9df1301d3e3c0f9b461cbe4f8b2963"
    sha256 cellar: :any,                 ventura:       "960c12f1976a0958516ae73e64c0f89bc3ab63f22f6e67caa136d525bce02101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b8581a1660f15ae4e36d19f4ff5d538ff1bead94da63d30f6fc1fd4c092bbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69010da69cd156f883b7d9cacfce823861227c0a66f34fcac65ea38bf971aad"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5c/89/36c09108d8d35e6f722cdc9ff169f003c7458657ecf04c3a375dca973ccb/boto3-1.40.54.tar.gz"
    sha256 "5f7dbf8539d26e0ee973baea49d0db8c1ee57707a785c5a23307241fdba04327"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d1/c8/8c7509d7fa26de03d21673f18a1edc1ac98198ba261a2b943774ed4f1c44/botocore-1.40.54.tar.gz"
    sha256 "808232d9fcbf2c295b6e7cd1897119ee2fb97e756edfb313aa6d27ba0b281c66"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")
    assert_match <<~YAML, (testpath/".awsume/config.yaml").read
      colors: true
      fuzzy-match: false
      role-duration: 0
    YAML
    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
