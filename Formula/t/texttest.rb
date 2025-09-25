class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/50/d2/5ac2d5f53a6b4b72d8485796b9abfa29a8bedd0c4ca08341a382425a49f8/texttest-4.4.5.tar.gz"
  sha256 "99243585979f016c2c89a38a3a3c61e942e13574fb19dd2c933261a3255daaba"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb9b37df685485270c05bfcdb017e2ecd1f6dcf3f004b5995042733624f53ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e7191ed85dc361be7f5bf9e347c478a7ec548c78740f729d13861b6e801fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3020337061ac37ea1f694c72e75b0fdcb19ddd1eff922956629870091a3185"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e327e89d05204683bda5e8bd799f7b40eb20ec89294d34e84ef04d5c2cfe515"
    sha256 cellar: :any_skip_relocation, sonoma:        "c012cf7f8ed85c00945604a78b93f3e3ecf3786e56c5dbebf5ea326bbb5ece5f"
    sha256 cellar: :any_skip_relocation, ventura:       "74d479d24fc3d719de60ac1fc179a840fadd1600097c50074ab4ad94b5676880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405d9322bcaad19db7074eaa3adf66f67e2f82a520d771809f4fa53652bb106c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71f95fe11e952b8ddbe339879354761f70c673898be9af66cf189ad00776f58"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
