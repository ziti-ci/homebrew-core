class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.256.tar.gz"
  sha256 "0ae96240ad25ffe463dee11157dac5e624e932b8b8843e95de005436c0a0879a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afbc91dd92197c9d83438354543e0feff7c4e832f870319513a31c6dd236dde3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afbc91dd92197c9d83438354543e0feff7c4e832f870319513a31c6dd236dde3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afbc91dd92197c9d83438354543e0feff7c4e832f870319513a31c6dd236dde3"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f44231a35e99f28b8f04ad8ae461abe88dad5a53a932b82c0139f3960c01e7"
    sha256 cellar: :any_skip_relocation, ventura:       "91f44231a35e99f28b8f04ad8ae461abe88dad5a53a932b82c0139f3960c01e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86560dfd79d4a2e6c65cf7eefd25337b9fa80e5b17d84af4af8e235d2326ffe"
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
