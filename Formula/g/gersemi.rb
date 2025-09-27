class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/e7/de/baafb537f824e0585561b70d7cf896a876e7c699887dec945a9c527e02b6/gersemi-0.22.3.tar.gz"
  sha256 "ae764e726ed2e9cefd696dc0f082fff77e2e51dd236c61739b18fee69fe406f4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fb385d2f88ec12193485bc7dac60f2bdab453b06832bfae53bca416ae1b5c7a"
    sha256 cellar: :any,                 arm64_sequoia: "2d508bb441ee26b37eafc43d37ca3b942c21b074611483da2506bb03295dc868"
    sha256 cellar: :any,                 arm64_sonoma:  "c74613b23263dec3746c1bf121759621c882c9ae7f090639513e9d5ce9a28282"
    sha256 cellar: :any,                 arm64_ventura: "309b69e73f6565a3544611cf31ce5c62b6b135fc0d82c3186531af2f2ceee2af"
    sha256 cellar: :any,                 sonoma:        "5a1402ce7595319739d4fc4816d82953c39ab666e2d99a9ac92130ce6595b417"
    sha256 cellar: :any,                 ventura:       "957e1716c269736bf16238bb850359ca625d25744e8337848756a41f555c19c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511a7afb4e1d262b4e167d626c06f5d55fc81c3263997ba196725c7c67097564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12a01d7220da9521b0848a1a012bac34f9a55abbb6bb5bf096bab7493fe570b4"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/1d/37/a13baf0135f348af608c667633cbe5d13aa2c5c15a56ae9ad3e6cba45ae3/lark-1.3.0.tar.gz"
    sha256 "9a3839d0ca5e1faf7cfa3460e420e859b66bcbde05b634e73c369c8244c5fa48"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
