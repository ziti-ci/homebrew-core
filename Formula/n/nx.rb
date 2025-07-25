class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.7.tgz"
  sha256 "909677001b9a85299e620c9911b4010197753be9431a96f4ae4dea916e018ba5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f70ebf86f515f4f0873e12ae542e3e1450b6b411cb932160030e0ed2ac47e98c"
    sha256 cellar: :any,                 arm64_sonoma:  "f70ebf86f515f4f0873e12ae542e3e1450b6b411cb932160030e0ed2ac47e98c"
    sha256 cellar: :any,                 arm64_ventura: "f70ebf86f515f4f0873e12ae542e3e1450b6b411cb932160030e0ed2ac47e98c"
    sha256 cellar: :any,                 sonoma:        "d2811fc8244f22a07c16535f3c30d26b27b246af87bf2571f773348875b6716a"
    sha256 cellar: :any,                 ventura:       "d2811fc8244f22a07c16535f3c30d26b27b246af87bf2571f773348875b6716a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62fac1d52c24de56daf99a8f4d3a80a6a274f1e770a8afee27ca3d029b27a26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf80f4c94d04f00bf135e0a2dc9640e21d2fc884453083dfe06a5435fcecc270"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
