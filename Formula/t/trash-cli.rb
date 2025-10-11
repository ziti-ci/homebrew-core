class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/f7/6c/d51b36377c35e4f9e69af4d8b61a920f26251483cdc0165f5513da7aefeb/trash_cli-0.24.5.26.tar.gz"
  sha256 "c721628e82c4be110b710d72b9d85c9595d8b524f4da241ad851a7479d0bdceb"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c258e086ee7080b6bdc83c313ce1a45a5c2ee1d9e5049cf0304d2aae8935f9c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3005369e1cfe7938d6c97d39614c2dd45bb87b06d2e7fb07e1616a201d8128b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ccc13a1742713858b3b63cc8feb9840596b901d2ffe5dc1fd9757ed2584d1ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4ea7729d8301971fd3970a2c72b8ab6d4a08df8b82a79d9146ff95e2880db7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81d30387db79999d4ce0eb0b656d97ac782c6de9531f6cd052b83311a145c02"
    sha256 cellar: :any_skip_relocation, ventura:       "31f699dac8d5ded90260901e92ccd1fd21c4319732b0efc258385bcd3c004411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa53d7fd0525290529f1de305a1e5c701e8c9948874526fb281e201bd36f6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4712d02377f336fb88f4de3ebc3c03dbfcf1a17d8e3d8aac297570a2938f5dd5"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.14"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end
