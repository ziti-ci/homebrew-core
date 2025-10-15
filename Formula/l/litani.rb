class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "1a69906fafb4f4289f3c2ca0a938334648d92b6863fe98f04674de2c3cec8e23"
    sha256 cellar: :any,                 arm64_sequoia: "676d02c0c841d8cdc51aec96856046bebcae3ab16964e0c87db010854e0693b3"
    sha256 cellar: :any,                 arm64_sonoma:  "b0f81f3f3209d4e7734802ccc252c2e24fc60a744c3abb8240c57633fd8c1dd9"
    sha256 cellar: :any,                 arm64_ventura: "e715dee1f738cefc1bfd130c464c9ef91788ff16b53a48ac53c5fe7d20e74fbb"
    sha256 cellar: :any,                 sonoma:        "aa8fe441a8999774f2d3b0d26e1c0b94b1572ff439de16767d3f825a282f7ace"
    sha256 cellar: :any,                 ventura:       "91594078221ca286cb43744cf228b1d727641fdbe4a21b85dad430bc3aa24031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9deebc99467682582aeb8c6dd2465f98363a06cfde6e1375c08b9b547c422d3"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "libyaml"
  depends_on "ninja"
  depends_on "python@3.14"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.14")
    venv.pip_install resources

    libexec.install Dir["*"] - ["test", "examples"]
    (bin/"litani").write_env_script libexec/"litani", PATH: "\"#{libexec}/vendor/bin:${PATH}\""

    cd libexec/"doc" do
      system libexec/"vendor/bin/python3", "configure"
      system "ninja", "--verbose"
    end
    man1.install libexec.glob("doc/out/man/*.1")
    man5.install libexec.glob("doc/out/man/*.5")
    man7.install libexec.glob("doc/out/man/*.7")
    doc.install libexec/"doc/out/html/index.html"
    rm_r(libexec/"doc")
  end

  test do
    system bin/"litani", "init", "--project-name", "test-installation"
    system bin/"litani", "add-job",
           "--command", "/usr/bin/true",
           "--pipeline-name", "test-installation",
           "--ci-stage", "test"
    system bin/"litani", "run-build"
  end
end
