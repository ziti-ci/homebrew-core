class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.14.0.tgz"
  sha256 "4aafba77b26328d37b6e1014f4a323769482d3e544c09e92c067dc9eee3650d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a922d1ba1ecd45b832061df3a8f5e8f003fff05a41ad9dc9b90d15f132aa776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a922d1ba1ecd45b832061df3a8f5e8f003fff05a41ad9dc9b90d15f132aa776"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a922d1ba1ecd45b832061df3a8f5e8f003fff05a41ad9dc9b90d15f132aa776"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6bc56b4917b03e929d5377f6620768ccb033dabde908f075056dfb4eebc64be"
    sha256 cellar: :any_skip_relocation, ventura:       "e6bc56b4917b03e929d5377f6620768ccb033dabde908f075056dfb4eebc64be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a922d1ba1ecd45b832061df3a8f5e8f003fff05a41ad9dc9b90d15f132aa776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a922d1ba1ecd45b832061df3a8f5e8f003fff05a41ad9dc9b90d15f132aa776"
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
