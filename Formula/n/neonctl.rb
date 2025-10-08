class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.15.1.tgz"
  sha256 "1081fd821fe0d5301366a77351662ad9e23315c6b81e32c5df5af3852a46dc5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f47ca954956a4d07e4af53aa4e283630f30c116b2a853323365fec15497828a"
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
