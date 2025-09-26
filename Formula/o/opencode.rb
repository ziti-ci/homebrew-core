class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.9.tgz"
  sha256 "0313d65aae011f90349561e29424dfca77071ac481aed1991c0a6b8cc9762c82"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8810faba6927c36c93eee79a3b28c9da04131bad40480f93e4796b18a03a945b"
    sha256                               arm64_sequoia: "8810faba6927c36c93eee79a3b28c9da04131bad40480f93e4796b18a03a945b"
    sha256                               arm64_sonoma:  "8810faba6927c36c93eee79a3b28c9da04131bad40480f93e4796b18a03a945b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27db3c0907925ec370755c43c1b35c7d7dbc0cfc38d9d1fefd00ea34500170c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82359f9e77860e0995c80c764fc863056296a7bee9a4ae396cff47abf3238ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93750385c25408a2afc665d90b9ecea50da7d85e586f1c3dd5296a6c10d0b218"
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
