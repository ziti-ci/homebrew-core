class BbCli < Formula
  desc "Bitbucket Rest API CLI written in pure PHP"
  homepage "https://bb-cli.github.io"
  url "https://github.com/bb-cli/bb-cli/releases/download/1.3.4/bb"
  sha256 "6c6c5e64b67b113d8d2249bc153303044a94a60c6017e3ed392c3a4087f54c02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cfd238d4feee9bc3c16451eac59ce27fa4ce8cec2bd0b3a3007e47b301c2a01"
  end

  depends_on "php"

  def install
    bin.install "bb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb version")
    assert_match "No git repository found in current directory.", shell_output("#{bin}/bb pr 2>&1", 1)
  end
end
