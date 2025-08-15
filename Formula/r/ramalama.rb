class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/85/1d/c12704e04e610e8a277c89858474db7790290f3b009c6615467a589405d5/ramalama-0.12.0.tar.gz"
  sha256 "a19c4ba3dd57848a1000ee9eed8798992b88883335a1d47c030b831ea9f8dab9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2290455f84935bc9d17875cd0a821497911099585e0509ec89aa3dcf9dc338b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2290455f84935bc9d17875cd0a821497911099585e0509ec89aa3dcf9dc338b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2290455f84935bc9d17875cd0a821497911099585e0509ec89aa3dcf9dc338b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de7fb407365823c5cbead811e769e7e88a0f9005a941a09d164e7b2946b174d"
    sha256 cellar: :any_skip_relocation, ventura:       "9de7fb407365823c5cbead811e769e7e88a0f9005a941a09d164e7b2946b174d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407cceedf34a51ea23bb95f21f1f1a563484530202a5cfe631b0a97726fe3c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407cceedf34a51ea23bb95f21f1f1a563484530202a5cfe631b0a97726fe3c85"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
