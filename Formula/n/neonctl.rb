class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.13.0.tgz"
  sha256 "2290ca6fae4f300a1efe96b76eb76ac1023d1313a4f6e5b51b000c88f0e6f11c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0efec7332769214154fb30f8c1ca5d2bda0250b341f90f55c2f9886c49ce2db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0efec7332769214154fb30f8c1ca5d2bda0250b341f90f55c2f9886c49ce2db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0efec7332769214154fb30f8c1ca5d2bda0250b341f90f55c2f9886c49ce2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "b795e547a71c5d91c65e4936c42cb425b1c125a2846404b78ec91e3c61573395"
    sha256 cellar: :any_skip_relocation, ventura:       "b795e547a71c5d91c65e4936c42cb425b1c125a2846404b78ec91e3c61573395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0efec7332769214154fb30f8c1ca5d2bda0250b341f90f55c2f9886c49ce2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0efec7332769214154fb30f8c1ca5d2bda0250b341f90f55c2f9886c49ce2db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
