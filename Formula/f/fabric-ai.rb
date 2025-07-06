class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.235.tar.gz"
  sha256 "e2591bc7c8664b07bf721d611c1da249bf020721e20cbbfb008709341a7bf178"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e6f1e4495b6878b72d1f4e20c53e012314452e314f12516516c2f14685b0710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e6f1e4495b6878b72d1f4e20c53e012314452e314f12516516c2f14685b0710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e6f1e4495b6878b72d1f4e20c53e012314452e314f12516516c2f14685b0710"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5ac30758c63ef53174410eee2138dd965d7209a8743c0136917a944121b621"
    sha256 cellar: :any_skip_relocation, ventura:       "3e5ac30758c63ef53174410eee2138dd965d7209a8743c0136917a944121b621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abbcd6cffd0b6ea5abc2305572dbf0d66c57f966f2ac1649b6e2976254b9445f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
