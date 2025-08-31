class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.13.tar.gz"
  sha256 "1a8b1e53263f181e0a6d433aa9dbdd21cf34098d2c9db5b177ef7250f5d0754a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "565798749e5d220bf2543a4daec0b5f7e8cc70a0e7b7cbde425ea185531ee63a"
    sha256 cellar: :any,                 arm64_sonoma:  "5025163b7fa90c358f2d5bbb489e91f396a8f7cc0a0f030600d7b96815daf1f4"
    sha256 cellar: :any,                 arm64_ventura: "8c2f9e4e28fdd4f3afd1812a36c3115110d54f1239fde99d8bd85552b4d8fa65"
    sha256 cellar: :any,                 sonoma:        "c3c8d7e0dd472bba93e746e5aec1596d0c646f399376597ef69e1fd26a411e0f"
    sha256 cellar: :any,                 ventura:       "ef33102b4950aabbf1349aacc0f18a8a779fd03c81f0b705a6ed3ee4603bd347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fc77d180e8e761e517a74838b6775dbe627ba725ac4ad17b2f8ec8b6472be78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2d4e720a7c31853a51626c12de01eea2dfb23e7cd188db775d8cfe259c7529"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2b/f3/13a3425ddf04bd31f1caf3f4fa8de2352700c454cb0536ce3f4dbdc57a81/dulwich-0.24.1.tar.gz"
    sha256 "e19fd864f10f02bb834bb86167d92dcca1c228451b04458761fc13dabd447758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/78/e2/e6a8f5598c1d1e1181776678691dc66f2cd74a745ef175ac15ac9d9c148c/fastbencode-0.3.5.tar.gz"
    sha256 "2445663753bb41ffba1c43e9e94e7c1145d1dd6f7c8f62a97f0585063ee449c3"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/91/e1/fe09c161f80b5a8d8ede3270eadedac7e59a64ea1c313b97c386234480c1/merge3-0.0.15.tar.gz"
    sha256 "d3eac213d84d56dfc9e39552ac8246c7860a940964ebeed8a8be4422f6492baf"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/19/51/828577f3b7199fc098d6f440d9af41fbef27067ddd1b60892ad0f9a2d943/patiencediff-0.2.15.tar.gz"
    sha256 "d00911efd32e3bc886c222c3a650291440313ee94ac857031da6cc3be7935204"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end
