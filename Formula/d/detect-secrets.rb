class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
  sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  license "Apache-2.0"
  revision 4
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67149495e58221c664a0643ec874c1e93b1e6a0274c99bbd39cbf2154b1ccde5"
    sha256 cellar: :any,                 arm64_sequoia: "31070714993ea18148c92d75ca9a04862aa0637630c0a5310bfac94646e18fb3"
    sha256 cellar: :any,                 arm64_sonoma:  "547304154066c8f09421bf3201b12255c4f205c6000af7755dfa3d87ec0ac2be"
    sha256 cellar: :any,                 arm64_ventura: "185aa3d13dfb246a32910bf08a949cdb2ac6ae7ecbe02496242e8d3e6c951cc3"
    sha256 cellar: :any,                 sonoma:        "f93351bf059c62b9c828114b523c30de2b0f30a90b5374456995b0edaeecd602"
    sha256 cellar: :any,                 ventura:       "2d844f5428d5c712ee263b709be14032705ae6102c1537832e1a7c6d51a31bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144aff2953b8c7c992334a2562fbff457be2d4b398fe502583bdba3b59026a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6470f6fbf104c17c2038877a296d80f6b8c0762c58050689ccdd562d3fe88777"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
