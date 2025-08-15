class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.7.tgz"
  sha256 "4dfc4b0a3e54c8744d76ac4e106d9de8c0e4b80fd12a7486c1ff4cee172f62f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b07b3ffd0bdbdc119cb763236dab8f60608a2585ebd1aac6f5d95f4d79a338db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
