class Badread < Formula
  include Language::Python::Virtualenv

  desc "Long read simulator that can imitate many types of read problems"
  homepage "https://github.com/rrwick/Badread"
  url "https://github.com/rrwick/Badread/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "236dee5ac99b8d0c1997c482df5b805908b0c34f75277ef706e897af71db1f9a"
  license "GPL-3.0-or-later"

  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

  resource "edlib" do
    url "https://files.pythonhosted.org/packages/0c/dd/caa71ef15b46375e01581812e52ec8e3f4da0686f370e8b9179eb5f748fb/edlib-1.3.9.post1.tar.gz"
    sha256 "b0fb6e85882cab02208ccd6daa46f80cb9ff1d05764e91bf22920a01d7a6fbfa"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test_ref_2.fasta", testpath
    output = shell_output("#{bin}/badread simulate --reference test_ref_2.fasta --quantity 1x")
    assert_match "error-free_length", output
  end
end
