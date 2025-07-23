class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.4.tgz"
  sha256 "a10005550fa522f3cba5c00f8858dc728b0f92f38712d15ebba15bb39ec9cc95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9da6e56ce77811ce33c4606b17da9b961ed973d1526545155b4397286c734049"
    sha256 cellar: :any,                 arm64_sonoma:  "9da6e56ce77811ce33c4606b17da9b961ed973d1526545155b4397286c734049"
    sha256 cellar: :any,                 arm64_ventura: "9da6e56ce77811ce33c4606b17da9b961ed973d1526545155b4397286c734049"
    sha256 cellar: :any,                 sonoma:        "aa7329cb948cf193c9ed6abaf60092af6fee69ddd497299045a895ac2a34eed2"
    sha256 cellar: :any,                 ventura:       "aa7329cb948cf193c9ed6abaf60092af6fee69ddd497299045a895ac2a34eed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07b9cdc5ff7aef206a2fb956b72716e96f078f51fbbc4d4cff330ebc07a2612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb544b0f5dbd03fe7192a5d1aab6a33362768cd9b3c083ef93a23b5c9c737020"
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
