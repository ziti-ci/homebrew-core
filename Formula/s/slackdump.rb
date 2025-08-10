class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "c9a6ba14f836ef38f3c465379f35420bc299a4fdae28228ee0c1d73021ca677f"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0cce64881d858421d4f8ece555735f8fb348324d2c8a91aa501835da112cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0cce64881d858421d4f8ece555735f8fb348324d2c8a91aa501835da112cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f0cce64881d858421d4f8ece555735f8fb348324d2c8a91aa501835da112cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3f3f7b43dbfa6ac3e5592858a88a8b06147e5bc93f09e4b7016ca491858673a"
    sha256 cellar: :any_skip_relocation, ventura:       "b3f3f7b43dbfa6ac3e5592858a88a8b06147e5bc93f09e4b7016ca491858673a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fab950717c850a236698d70d775b7d6f255e1e4ebfda4c58277528c29fb3666"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
