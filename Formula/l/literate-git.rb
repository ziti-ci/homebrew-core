class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/0e/e37f96177ca5227416bbf06e96d23077214fbb3968b02fe2a36c835bf49e/literategit-0.5.1.tar.gz"
  sha256 "3db9099c9618afd398444562738ef3142ef3295d1f6ce56251ba8d22385afe44"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0669579e7b1afc2c29040d7e2f5cacf7ff44682fc173974acf6f3a11ced22f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78fca9768aa28cc91c7fcd0fdb6f74e6d2edab8ff267912ee079a0d13667188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97beb2e869acd67d690d1a51a32f49366b73e3cc6aaad8ea0e7384b8ee493645"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72e3eb02cd1b9f4656d7c2a1cc941f9c61caebc5c3d134f18364bc0cd896f889"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d21c7e6ada9f49184787a19d7fd67dda9e933e3c267f5af318ad90fad3a9aa4"
    sha256 cellar: :any_skip_relocation, ventura:       "4719c71162e17145fcafbd29a0b78341fbba740191ea2b4533072350560db2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e546f0a8bcc036eb4925142d5f5c60b41ac909d6bba3cd89b21e800a02fb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a17d82f86fca6482e0d1ef72023b9f8ba90837247c7116661a2c8b8cc9e001"
  end

  depends_on "pkgconf" => :build
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/42/f8/b2ae8bf5f28f9b510ae097415e6e4cb63226bb28d7ee01aec03a755ba03b/markdown2-2.5.4.tar.gz"
    sha256 "a09873f0b3c23dbfae589b0080587df52ad75bb09a5fa6559147554736676889"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~PYTHON
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    PYTHON
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
