class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.4.tgz"
  sha256 "a10005550fa522f3cba5c00f8858dc728b0f92f38712d15ebba15bb39ec9cc95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ca27f0e3683d24def2fd7d8b8f5e7756d0f6935a46c1b3cc138539f3244f9ee"
    sha256 cellar: :any,                 arm64_sonoma:  "3ca27f0e3683d24def2fd7d8b8f5e7756d0f6935a46c1b3cc138539f3244f9ee"
    sha256 cellar: :any,                 arm64_ventura: "3ca27f0e3683d24def2fd7d8b8f5e7756d0f6935a46c1b3cc138539f3244f9ee"
    sha256 cellar: :any,                 sonoma:        "0f736a0a39cd101a99fe9fd0399be1427142e5f18dcab6c3e83f6ba4d4f5daf7"
    sha256 cellar: :any,                 ventura:       "0f736a0a39cd101a99fe9fd0399be1427142e5f18dcab6c3e83f6ba4d4f5daf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f0423dd32313696a05a0b7805475b5b5e607411a9297b94e909e923aff09f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b6566ac307c6806e755d0b72d83bb19f806167ddc729deb17451201f9c3abd"
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
