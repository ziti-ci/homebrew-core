class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/14/a3/931e09fc02d7ba96da65266884da4e4a8806adcdb8a57faaacc6edf1d538/mypy-1.18.1.tar.gz"
  sha256 "9e988c64ad3ac5987f43f5154f884747faf62141b7f842e87465b45299eea5a9"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2014451f3638c5d5def74cb344e037046f2564b245a4b250288021144bb734c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf5baaa9e67514638e03108bac45cb84e9605fd09d032f9494379c8de736472"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce1768813ae5a3dadc78eec109cf911efa8b489c1852dc06ff2ca6c8a50ec5ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "413edfa6e036df37fc28e9016ca6f6b79e5efc854c2f99d59fa444eb42efeac2"
    sha256 cellar: :any_skip_relocation, ventura:       "c991191c9c93d6bcf92a7a7ee294f4c5cd74fc5fc28f22f9577b42c54b42ab54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8ee0aae32bca41a7d6b7f8ab8b934b825dd605e916224a631c69c47ef4a617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b375096f7aefaddea8c9db0b5afcc2220fb4d936e920333e2cd2b58971de9ba9"
  end

  depends_on "python@3.13"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
