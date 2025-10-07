class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.5.tgz"
  sha256 "2e841be1821ccd2f8c18a5792da6f823ee0d6041ea95815ab11bc2a1f3817174"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3e47000c5dcf27504d4c2383d475cda522ca2620c6e31b09b1131bd702396a21"
    sha256                               arm64_sequoia: "3e47000c5dcf27504d4c2383d475cda522ca2620c6e31b09b1131bd702396a21"
    sha256                               arm64_sonoma:  "3e47000c5dcf27504d4c2383d475cda522ca2620c6e31b09b1131bd702396a21"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98725fc9571e270ae55d75ce7af9b6b475c52cbc3da4e9a1cfeff7acfc32fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58aa7b1911fa49ca004b3fc9929dc458aa99eedb6e45d8eaf1f8a1b12205926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e4cffeda7b7fff0670b57a1335dbfc32912d4a77e2cee12b9002f625d3b35b"
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
