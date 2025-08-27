class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/mongodb-labs/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/70/ff/16fc299ee7ee4a2f48fc9a6eefde91ab0817073437da39b9c1cda3e4045e/mongo_orchestration-0.11.1.tar.gz"
  sha256 "53e70343ab6d3e2085a45f8c16d60244308d9e8964bd92ef38a21928cef68a52"
  license "Apache-2.0"
  head "https://github.com/mongodb-labs/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cf1ca98e8cc1d53a511e305356720f88c7df9fe43ca546c964e68d2f04c0b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5fdb25d4244126dacbecdd7e690bec21e0178b82309084acd5ba2c9e0e7742"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a395a66ec70d7ab1da4ed99fb3bc5f979cc4b79089ce528273e1e116597fcd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a5d766859713b3e0118fb349ba6f080787cde06cfadeef5f4343a412fc72147"
    sha256 cellar: :any_skip_relocation, ventura:       "8ee4a65d23ea5b3e4a62ba36da59c0d2ee4cf0de7aee9216dadb608a9b20dfa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25276e23929a2d1ee969b9256613d356be8ac00e1b6809809aecc74e93322a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ed36ee9e206f5b3c1f80b45abeae3f23820e532a4332c4f48f0d8b03faefdb"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/a1/d4/8617dbd734a58c10016f854c96a6aee522d90c4cf8890104c83f47c20126/pymongo-4.14.1.tar.gz"
    sha256 "d78f5b0b569f4320e2485599d89b088aa6d750aad17cc98fd81a323b544ed3d0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin/"mongo-orchestration", "-h"
  end
end
