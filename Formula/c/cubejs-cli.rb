class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.52.tgz"
  sha256 "64f22e974ea60344e0fae73fd47d3eb93825b407054e43808996bc3597b492a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fd878d9466f12177ea64a8bc9c1fabb4c3bc1665e016a981de9ef2154617da6"
    sha256 cellar: :any,                 arm64_sonoma:  "5fd878d9466f12177ea64a8bc9c1fabb4c3bc1665e016a981de9ef2154617da6"
    sha256 cellar: :any,                 arm64_ventura: "5fd878d9466f12177ea64a8bc9c1fabb4c3bc1665e016a981de9ef2154617da6"
    sha256 cellar: :any,                 sonoma:        "64c3cededfcdf13d3260b09200ec810b371613952c2b8ccfc9ad5bc89e85483f"
    sha256 cellar: :any,                 ventura:       "64c3cededfcdf13d3260b09200ec810b371613952c2b8ccfc9ad5bc89e85483f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a07d9e3e2ee42b56cc7659e421eac8cdd6b1ad1d6ef35f143f80431ba5b62058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659f49a470bba0eb060f72911f10e0811d121cc93e0655b5d1a212a887ecb505"
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
