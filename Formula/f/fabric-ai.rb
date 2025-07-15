class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.247.tar.gz"
  sha256 "9c17bc94a17d1c134d97c7f8b851f1a0c0dfc4e6e459131279bb97e1d9869093"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f0b57b085eacabfef371b309186030852f12f5e72e1d10c8b13b952248bec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2f0b57b085eacabfef371b309186030852f12f5e72e1d10c8b13b952248bec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2f0b57b085eacabfef371b309186030852f12f5e72e1d10c8b13b952248bec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2d412a12f1391a9ac0498a79b54dbb2348cbcb344af2421bd23cff4085f2b90"
    sha256 cellar: :any_skip_relocation, ventura:       "b2d412a12f1391a9ac0498a79b54dbb2348cbcb344af2421bd23cff4085f2b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d819182c2f9b7321df7fe79aa7619fc3e500deb5c30240c5cfacc4594c48e0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
