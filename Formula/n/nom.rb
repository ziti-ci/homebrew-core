class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "765b1a70790c7b2a2272adc9863b82b05db8a040ce5b35b5f25b0b816ed2f553"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43c3eb4fedc376b1aa0ac63a9879c7ab7fe0b7f39cace0490207aa9ec7ef072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2f54ec86b5ab3307e1b76e14ddafdff5a9836560c396ac73d8c02d41b002c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7344965f4b7fd8f5434ac3adb8fcac0b58c10acec26eea75408528e77d0ed29"
    sha256 cellar: :any_skip_relocation, sonoma:        "a239a78f7216f75546e98895c25b5dd394def5f6d6a9b3abc79b3fa244b270e4"
    sha256 cellar: :any_skip_relocation, ventura:       "ac30bcd8ccfaef9de1b3376e022ed47402d8b8f39dd92ffc04cfaf30d8225877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee12b71e50cc3f0fa83562d598e4adc57fb9b59c48f5c1aae1222570fc31216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614fa0d3ca6a67781b6107d7d9752f863c499b6516ba808322865e574d33afc6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
