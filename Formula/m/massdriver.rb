class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.4.tar.gz"
  sha256 "fee7bfd38dded3b735b220b1b24759e4df158806d905122465917783833676e1"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4133c6adf8311e60b7dc5aa744b944519d954358d1d4b5cd994c6f0b603bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc4133c6adf8311e60b7dc5aa744b944519d954358d1d4b5cd994c6f0b603bc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc4133c6adf8311e60b7dc5aa744b944519d954358d1d4b5cd994c6f0b603bc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04dd55a0bbdfd11a3526c805dbfc67b42993fa13aab473233b475b7f8718f9b"
    sha256 cellar: :any_skip_relocation, ventura:       "f04dd55a0bbdfd11a3526c805dbfc67b42993fa13aab473233b475b7f8718f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3272565a05a36934dbc03c540afb9e71d74634d3d0570622791232954d092799"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
