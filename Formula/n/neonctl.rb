class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.13.1.tgz"
  sha256 "e9d80865e5b955eeec0c47f6aa0635be824c50548bd46c33b7fda40819e07c02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f893cb209dce0aa3d2e904c200d53e9fea7cec14ea46e625e15328f5d6c47fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f893cb209dce0aa3d2e904c200d53e9fea7cec14ea46e625e15328f5d6c47fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f893cb209dce0aa3d2e904c200d53e9fea7cec14ea46e625e15328f5d6c47fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f2fa01afa0fc349ba3d3e02eea4a15e442a5c9e935f36d63e41c3c21de7e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "b2f2fa01afa0fc349ba3d3e02eea4a15e442a5c9e935f36d63e41c3c21de7e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f893cb209dce0aa3d2e904c200d53e9fea7cec14ea46e625e15328f5d6c47fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f893cb209dce0aa3d2e904c200d53e9fea7cec14ea46e625e15328f5d6c47fa"
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
