class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.5.tgz"
  sha256 "2e841be1821ccd2f8c18a5792da6f823ee0d6041ea95815ab11bc2a1f3817174"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "71b3f2edaea7becfe114d8f2a8629bbc49bf6ad557b6056850dd24669bf028f7"
    sha256                               arm64_sequoia: "71b3f2edaea7becfe114d8f2a8629bbc49bf6ad557b6056850dd24669bf028f7"
    sha256                               arm64_sonoma:  "71b3f2edaea7becfe114d8f2a8629bbc49bf6ad557b6056850dd24669bf028f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "abaee0d91a04a1bd4ee45b3959862c1fdb44b01d8796b40f63116f41d7145647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2843e8d8179d85ff37f9d62beddd9560baea3ee9768546191ab4fab3088309f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd23deede3ac112c7fefaa3080160f8242427712e9b41a6278c00a4efa45e175"
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
