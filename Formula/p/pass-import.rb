class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b439f4fdc85cb4a5285103bc8c3fc3526800e53611706534e53085ab68940776"
    sha256 cellar: :any,                 arm64_sequoia: "59113cfc585169c49622aff41d2e9d816d3e44df9978d5b3c80d469abf6e879d"
    sha256 cellar: :any,                 arm64_sonoma:  "434d68c3443172d74cba7292657dc1e9e9a03c1ce1c781cb7002cc34d701d8ff"
    sha256 cellar: :any,                 arm64_ventura: "0063ce827cea806f2223ae3c01c57912e06716770911f630c864271698880d89"
    sha256 cellar: :any,                 sonoma:        "886c4535d374cd68f9902119b43c9733a23f0c99fdd0879aa682c9e01bda9425"
    sha256 cellar: :any,                 ventura:       "99635afc19cd18f9c90d538d0e21ca0f71fb4dc7110320b451cc375fc016d3e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c26ce676ee18c6e0b30305d8808a9bf22d6baa9dbef19a1d359c96fe7f4710c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d80cb51ceebc3365946d91bd31998ad42b6808d136221c06c32f1358bf3179"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/c4/01/41f63d66a801a561c9e335523516bd5f761bc43cc61f8b75918306bf2da8/pyaml-25.7.0.tar.gz"
    sha256 "e113a64ec16881bf2b092e2beb84b7dcf1bd98096ad17f5f14e8fb782a75d99b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
