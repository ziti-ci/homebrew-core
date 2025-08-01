class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.45.0.tar.gz"
  sha256 "127ef4540ac374868fcc430c1ef15d0843282d4b4a6026cb71182887c4826919"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7cc421dfbb934d00aa95e26e31796de67dbc2841f5ee3dfd32a7417b207fba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7cc421dfbb934d00aa95e26e31796de67dbc2841f5ee3dfd32a7417b207fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f7cc421dfbb934d00aa95e26e31796de67dbc2841f5ee3dfd32a7417b207fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "974a8855cc20c34a6f445a56dca33e71981703ba903b9b9e3dcff98fe200d3ec"
    sha256 cellar: :any_skip_relocation, ventura:       "974a8855cc20c34a6f445a56dca33e71981703ba903b9b9e3dcff98fe200d3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b1df332f5e63fdbc508860f0b9f380275fd1d3735967a084283097874dd80d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
