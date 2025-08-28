class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.61.tgz"
  sha256 "1c5e1e827fdc850a4028bae03871e0b7c5c764388a23613cbd209986be859566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e107282de789ef132cc8c8a1a424e66fad8bd6a17da46c719c77673608266d8"
    sha256 cellar: :any,                 arm64_sonoma:  "0e107282de789ef132cc8c8a1a424e66fad8bd6a17da46c719c77673608266d8"
    sha256 cellar: :any,                 arm64_ventura: "0e107282de789ef132cc8c8a1a424e66fad8bd6a17da46c719c77673608266d8"
    sha256 cellar: :any,                 sonoma:        "8ec75dfa2dcb65b9b934bf54331b3a1457bbbb2c5ebf1da17dde0db973ed12ab"
    sha256 cellar: :any,                 ventura:       "8ec75dfa2dcb65b9b934bf54331b3a1457bbbb2c5ebf1da17dde0db973ed12ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91096a56db55c38ecfb1f86da4471845e88c2e71ce3a9435e8be1493cfe37262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc3f7f3a63f781a1f36c005e4af34aed821c6a87ec28a3586a9836774db772f"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
