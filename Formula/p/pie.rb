class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.2.1/pie.phar"
  sha256 "b3a30c3e70f6b590505f76e27f1163b328b3523f369200a8f769ca1005ac42f7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55d09f463e144fc234c2e6b5bba1e8f786d96e8d881bb6b8353f39ee5827c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55d09f463e144fc234c2e6b5bba1e8f786d96e8d881bb6b8353f39ee5827c8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b55d09f463e144fc234c2e6b5bba1e8f786d96e8d881bb6b8353f39ee5827c8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8885538e0f2a651fdd177fda5825ecd09235cc2d00a98fb5ce3695149a524765"
    sha256 cellar: :any_skip_relocation, ventura:       "8885538e0f2a651fdd177fda5825ecd09235cc2d00a98fb5ce3695149a524765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8885538e0f2a651fdd177fda5825ecd09235cc2d00a98fb5ce3695149a524765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8885538e0f2a651fdd177fda5825ecd09235cc2d00a98fb5ce3695149a524765"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
