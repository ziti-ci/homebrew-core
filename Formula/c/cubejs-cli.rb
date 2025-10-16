class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.80.tgz"
  sha256 "a50580f80b2857ad640790748740777b43334f97d27ca12775959f46efa7e7b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c208964c0876461551b7521e2eca9c8e0fd798f54ed010c49e32caf1b33feb0c"
    sha256 cellar: :any,                 arm64_sequoia: "a63d8d671584bb87d1411dff4c432ec1bedee370a8de8f4e2c25201f5f56e9bb"
    sha256 cellar: :any,                 arm64_sonoma:  "3681e6b7bfed44635927c296f216cb97a4da6cc438f36a2c08ad9c4bb8e1307b"
    sha256 cellar: :any,                 sonoma:        "49c699c4bce1c3b35256c67cf71dc1057307a0cbca736e68b0541d2726eb30b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ce9e0e03a70e7150f226efcd6228a89f75377fc756535f0626de068bd48c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a6c10816cc29b420a9ffea09f87aab70102c1ca5135fae61201c33d68f58a4"
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
