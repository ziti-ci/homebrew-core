class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e1/74/b8a08017ba9dcf55487a60fc645b7e57c347281da11cd75b5d7584c03faa/nvchecker-2.19.tar.gz"
  sha256 "247c7aca76ce55fb44f1a7718566f8312f473796ae7f4107cd193e1d6dba2883"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee58e23564e61fa16c47412a8ff0371f01556401369a7a0bc9ca7b9c85ae46af"
    sha256 cellar: :any,                 arm64_sequoia: "ad876d36ee941d0dacf20f44e0ff1d0c11028daf4bfb04e1d6f40f011e82e363"
    sha256 cellar: :any,                 arm64_sonoma:  "7a87bbcf415913cc7ce0f678323d22d43615dc063a8d5b2f6df57bbebde55029"
    sha256 cellar: :any,                 arm64_ventura: "6830458d6d49fdb102c00426bd290e9068189a795c5b42519b471c061dc25b75"
    sha256 cellar: :any,                 sonoma:        "b3068074a6258047f0f822b9b8a09f0769a2998b52ede9154e0a416bddcfece5"
    sha256 cellar: :any,                 ventura:       "7f1d4c6919cbfb439ae79471608fb354a122ca28dbc5cce0cb6197ef26790a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41d23e6facc333e208972d1cba0e8c98aa7476141db18c53fabcd60aaf3b0d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7939e7fd902762de09d2fe2e74b3eab43f179239fcf31e2c55a1e496909ccd35"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/79/b9/6e672db4fec07349e7a8a8172c1a6ae235c58679ca29c3f86a61b5e59ff3/structlog-25.4.0.tar.gz"
    sha256 "186cd1b0a8ae762e29417095664adf1d6a31702160a46dacb7796ea82f7409e4"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/09/ce/1eb500eae19f4648281bb2186927bb062d2438c2e5093d1360391afd2f90/tornado-6.5.2.tar.gz"
    sha256 "ab53c8f9a0fa351e2c0741284e06c7a45da86afb544133201c5cc8578eb076a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
