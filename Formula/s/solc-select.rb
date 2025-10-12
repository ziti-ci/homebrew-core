class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
  sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff19ef790a74550e13f04d15b69fd7538644a0d7883f7e596edf23be45867a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3957a265f7ca3d516f7c3faefc58c9bce7d53644395922223d2210836c5a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36ea54913d7a7f3d7c1085ffd19833e8be6a40228326afb5a73983557df19c63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "742ba15309a69e1de2019f7d96a5eff594086049cb29e676111296ac5d85cab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8be48b55beeaf881ebcf778dc87ba5f3041337c6c39745a5498eeab6a1ab9dc2"
    sha256 cellar: :any_skip_relocation, ventura:       "25521bbb2e161e5e4dda3528b8db73492ff8c452b9af2210b94e41ec8eb77a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dfff3b8b387a2dfdff1752ec12ea03850b75284052b59ba0ec008c48c45acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e29ee66be49ea56f3c7c901b16cbde55f6505572b57a933e92083d3443d986"
  end

  depends_on "python@3.14"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match(/0\.5\.7.*current/, shell_output("#{bin}/solc-select versions"))

    # running solc itself requires an Intel system or Rosetta
    return if Hardware::CPU.arm?

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
