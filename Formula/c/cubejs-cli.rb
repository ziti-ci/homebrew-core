class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.66.tgz"
  sha256 "9369a4a753ec72bb5725c304d3b877dfb9509cdf61e985363829ea93d548282e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da37a39b7b6b5cd44c8d24a4c8361b3542828310e769dbcf3b6071b44f0ec295"
    sha256 cellar: :any,                 arm64_sonoma:  "da37a39b7b6b5cd44c8d24a4c8361b3542828310e769dbcf3b6071b44f0ec295"
    sha256 cellar: :any,                 arm64_ventura: "da37a39b7b6b5cd44c8d24a4c8361b3542828310e769dbcf3b6071b44f0ec295"
    sha256 cellar: :any,                 sonoma:        "8ec4c7e37b8eeb13ed3777ff027e0661b58f4c4e099af66d0cccd3a0f4ef6500"
    sha256 cellar: :any,                 ventura:       "8ec4c7e37b8eeb13ed3777ff027e0661b58f4c4e099af66d0cccd3a0f4ef6500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5c58b92feb2f6c869a38394ae1e1f4e30050c15fca03148f66593fd0f5abb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0446bfe2af5b508c469d0bddb6bd745455400514966a646532947769d4f958e3"
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
