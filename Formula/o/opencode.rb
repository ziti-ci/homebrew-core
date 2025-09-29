class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.13.4.tgz"
  sha256 "277a1ef78288f63e1de5fc98712640d0c51987fd1337bce4110983bd73acd0c5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "14641063172b1196a3585a30e09898eac7ebe271528ec32ee2819f232ceaa4b9"
    sha256                               arm64_sequoia: "14641063172b1196a3585a30e09898eac7ebe271528ec32ee2819f232ceaa4b9"
    sha256                               arm64_sonoma:  "14641063172b1196a3585a30e09898eac7ebe271528ec32ee2819f232ceaa4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0a6c5fbed214c7c329e72948b8dfb3730ac301db97929ff4516ad0997fb56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b6beb4bf895f2e11cbc062dc38f590925c5b2f4fb2369e1c2e42ebd4555dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2191f7263a76d445adabcdf1754339a58ca8c5142b61f0c1d77f98a3dd0f3a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
