class OpenAdventure < Formula
  include Language::Python::Virtualenv

  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.20.tar.gz"
  sha256 "88166db3356da1a11d6c5b9faa0137f046e6eb761333c8d40cb3bcab9fa03e4a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9302436fba74b8157dab30c645b659316552a14054320cbeb45c5b21568a3faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eec5f4234610108d0981675069e9cb399629b5583375e8a3646cf40106ce84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79ead7a8777908582bbae02d996718401ad1e8ac590bc67acb9f47e90f6bdf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37eb08a624d5b0bed4316bdf8cbd41a32d61a47aa1049d6f14102b26cd3a7f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b1fc41c2bafbc1d51339ff08dfb7368014c747ed611230760e41007885dca3"
    sha256 cellar: :any_skip_relocation, ventura:       "48635b97a030dc943aa46c63ffc9d2577364d2c9b228361b3dc699db76d68976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f83e115dd977b51f17c67a75324e40803f45791dec3539e8a8e6115098047b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd8abc0993bac8839ef252f7e567b40760072687fb0fd982967c599c19e758b"
  end

  depends_on "asciidoc" => :build
  depends_on "libyaml" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    venv = virtualenv_create(buildpath, "python3.14")
    venv.pip_install resources
    system venv.root/"bin/python", "./make_dungeon.py"
    system "make"
    bin.install "advent"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
