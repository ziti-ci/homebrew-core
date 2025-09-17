class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/0e/c0/9c28acf903566a02de43f8fc6c572b8195ab0fa854016825e5690c77b57a/eralchemy-1.6.0.tar.gz"
  sha256 "8f82d329ec0cd9c04469adf36b8889b5ea2583e7e53c0fd2e784e176e1e27c7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92b8479641ef4c6ac261b9a86f2de35ca4e9abb6fa56f2b36d2c8e4be27e0606"
    sha256 cellar: :any,                 arm64_sequoia: "08649146de0cdf02e659ede3d8a0abcf22ceef117c63df9f556414137f04d692"
    sha256 cellar: :any,                 arm64_sonoma:  "f18d6b415538d24a6777d5589f0a1c36386a541765baef679e9152f36c9d2f47"
    sha256 cellar: :any,                 arm64_ventura: "bcbea307eb470ce0f6a1ed9ec24536e421be304087f58b4669f970a514f33fc6"
    sha256 cellar: :any,                 sonoma:        "285c6bda5678f036aa4315660073df0bd86e68f9a761fe66a5ea4f4a8be3f4bf"
    sha256 cellar: :any,                 ventura:       "90a5befab4b548f14b9a203fd1c802910b9ff3511653d62666f338a814d489b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eab42a4e1af97949850753589b99b101b5e66c6d2b3fcdc6f6caabec7d388ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be4ace8ed5abe63973efc16f9c8a88b99a267743d05ae0045ff8d58c841d02e"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/d7/bc/d59b5d97d27229b0e009bd9098cd81af71c2fa5549c580a0a67b9bed0496/sqlalchemy-2.0.43.tar.gz"
    sha256 "788bfcef6787a7764169cfe9859fe425bf44559619e1d9f56f5bddf2ebf6f417"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "er_example" do
      url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/refs/tags/v1.1.0/example/newsmeme.er"
      sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
    end

    system bin/"eralchemy", "-v"
    resource("er_example").stage do
      system bin/"eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_path_exists Pathname.pwd/"test_eralchemy.pdf"
    end
  end
end
