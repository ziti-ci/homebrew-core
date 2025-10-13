class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/c3/ae/4e19a7477f65d432421a001af03d70e2caafb4f7398d791b28bd8d47a892/pytr-0.4.3.tar.gz"
  sha256 "efd6f11506e2be93d7c0e0e4fe4feaf9cb6b466beb76ba2ef03c6197d3ab719d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe6aae99a6371d6dd98f92265d2072262f65eefa1819c8b3d652dd0bbab9e34c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e15180dc894fb8d6b5e8e0d428c2d475d3cfc3a4b9d35f483bb4ef39d7b3afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f203c500eae91979de17e169e36e73bd74b4dde9dfb2020ad753f7d2ef14ac0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "090fafa62e298525f98595525eb6d6067f3f4e0b031df693672c9d4baf7183e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "259a655a1e4bcde2d31076f038b1c9d603eb493ae03ac013fea322cdc640dea4"
    sha256 cellar: :any_skip_relocation, ventura:       "0a657f178c6ae21ac8f10a7cd1000ebf973eecc65e7ceee1d565e1241a25a770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acbadf148c8be40f6dfad04e50a2f08ffb73a89b33509157a4881ff6ac543ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3258625c0144224b99878d1fc501df98a51cd832213d31c8c773f883f165b28a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/c0/1f/924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46a/ecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/88/f8/175b823241536ba09da033850d66194c372c65c38804847ac9cef0239542/requests_futures-1.0.2.tar.gz"
    sha256 "6b7eb57940336e800faebc3dab506360edec9478f7b22dc570858ad3aa7458da"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pytr", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pytr --version")

    assert_match "NUMBER_INVALID", shell_output(
      "#{bin}/pytr --debug-logfile pytr.log login -n +4912345678 -p 1234 2>&1", 1
    )
    assert_path_exists testpath/"pytr.log"
  end
end
