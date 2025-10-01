class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.5",
      revision: "8696231b52efc02e322102545fbe97a74c4a60fa"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60a919a47b927c30b1d15f3216b32bb579adfbd0b238be27844e24fbfc1ed6e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a919a47b927c30b1d15f3216b32bb579adfbd0b238be27844e24fbfc1ed6e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a919a47b927c30b1d15f3216b32bb579adfbd0b238be27844e24fbfc1ed6e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "27a53051a5a713bef6b2de413f22659efb69efafb5cd96146c8430434823be72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a0e71cac387bca1aee0cbe0b9e547c42586ba965b2508b751475ca0f20d8b4d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
