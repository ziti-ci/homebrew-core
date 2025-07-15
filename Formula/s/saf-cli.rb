class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.22.tgz"
  sha256 "4686e49d17dc6c1a11160dd2ffb069cce80af44b518a77e1983ec8f009735b07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a9a7c46e657b0a4687995faba15adaa1e2eb11f6bbd5d4cfe285aa82df68f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a9a7c46e657b0a4687995faba15adaa1e2eb11f6bbd5d4cfe285aa82df68f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60a9a7c46e657b0a4687995faba15adaa1e2eb11f6bbd5d4cfe285aa82df68f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "469c74ffaacab103c9b351527fce01511dfd14844b85e3cff1cfd69058657b76"
    sha256 cellar: :any_skip_relocation, ventura:       "469c74ffaacab103c9b351527fce01511dfd14844b85e3cff1cfd69058657b76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea18c573baec0ee385521edcd37677ca3f6bf3bdb1798aa2281760db00c49324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a9a7c46e657b0a4687995faba15adaa1e2eb11f6bbd5d4cfe285aa82df68f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
