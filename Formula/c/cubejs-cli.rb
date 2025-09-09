class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.67.tgz"
  sha256 "c95bc6002cf254a4ae9891dc7665b0e95fa4e41368cce35861c6285123c7c23f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83f7029fc592e9a8e30bcefc2777675fc4f316629bffc1478993ff4d1fc7588c"
    sha256 cellar: :any,                 arm64_sonoma:  "83f7029fc592e9a8e30bcefc2777675fc4f316629bffc1478993ff4d1fc7588c"
    sha256 cellar: :any,                 arm64_ventura: "83f7029fc592e9a8e30bcefc2777675fc4f316629bffc1478993ff4d1fc7588c"
    sha256 cellar: :any,                 sonoma:        "3252c77f927518f9e46f4f3c54974217def2987cfcffcb9b44e1b849880691bf"
    sha256 cellar: :any,                 ventura:       "3252c77f927518f9e46f4f3c54974217def2987cfcffcb9b44e1b849880691bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b10ca660ee79c1c9f922ca0e17e4adf14bf18b56a06bb1339367bdfa28e94fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4469311409f2cf313178f92a486e6d87b8c45d8c1db0b3c3f147c2bd1a63bfb"
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
