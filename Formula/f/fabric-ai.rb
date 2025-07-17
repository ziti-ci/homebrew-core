class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.257.tar.gz"
  sha256 "ccaa4c70f2a7a182525b0bc33b457eb83178970472843ebbc3c9272ecec3a5b4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42987fa97ab71d820b13788b5acdfea55329776f9c49a30b0cb1744121a872c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42987fa97ab71d820b13788b5acdfea55329776f9c49a30b0cb1744121a872c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42987fa97ab71d820b13788b5acdfea55329776f9c49a30b0cb1744121a872c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "45339ae3340750eb6ca0b763840654ab57def04974f0ffdefc8a9f9f0a830f54"
    sha256 cellar: :any_skip_relocation, ventura:       "45339ae3340750eb6ca0b763840654ab57def04974f0ffdefc8a9f9f0a830f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a21fb3feb3688cebb57f980be0e0d6b79a282b35dfc06351f513ff7a22a1858"
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
