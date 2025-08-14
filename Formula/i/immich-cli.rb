class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.78.tgz"
  sha256 "a65bf17ac0879fd6710f4e5eb5f3f7cfab2b01d5643fa153c336d7f75071569e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddb937885fd0fdafcb7aca99c8b414af28b3bc9b814698a6013d6430f16bc9ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/immich --version")
    assert_match "No auth file exists. Please login first.", shell_output("#{bin}/immich server-info", 1)
  end
end
