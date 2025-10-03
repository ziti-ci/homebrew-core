class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/8e/5a/5c7fc1aca6c2db12379a9a511682dd58ac64bc505792bd84ff1995d594e9/translate_toolkit-3.16.2.tar.gz"
  sha256 "eb63bef9d9aa49901cfa327061694d8cf048d0877198792a9ac6ab1a78828175"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38fe76407ede997c977a3771fe22b23cedc39d22d624c52a59507829aa564739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd290bb9378f7fd77ff1a3e9633a64025863f52ebf7db5bb641ffb9aa7b9f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2435c21bb84820d2cda2fd3d298cd2f4c7b4557ca82b39c085c6043d2c116079"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "455d4fcd2321b625f46726b01f6f277284c5f97b0797cc9ce2771b782be5f747"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a4a8b2351dcd84fa6fbc8ef6c24e5b4b5e758e33d3b116ed7a6afa2e1e8831"
    sha256 cellar: :any_skip_relocation, ventura:       "597fba962e80c6402140dfbffce98c310139761e00098af97cdb53128d0a1b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927d898603e248a032da3c66b2f952c08fc6ca56a28ede1de9b07a3b7bf0fa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f922270e813f86da6d45444997b8ba4c0801c4e7b5a788efaa35c7bc8b36e7cb"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
