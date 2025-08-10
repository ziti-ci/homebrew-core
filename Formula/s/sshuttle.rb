class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/f3/fd/18f958bb11d6ae59c8a1388bf03152499270eb9e2ac5ed544b551a693f4f/sshuttle-1.3.2.tar.gz"
  sha256 "eeb2eee300a7de16117a86bbb9adb7b0647158edccfb8076f260e0535a439448"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d18d85477c5d6d21b3cd3402f34a358ea9fb4d219712f71949e3935971ff3bf"
  end

  depends_on "python@3.13"

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end
