class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.252.0.tar.gz"
  sha256 "216950184a6420e6662b952d77988708bad17f597d6f70d97cf514198b10e424"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95baf981207b11bf6658391b97cf757c2242e4d8eae2f20f20d9481f38ec31bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f34eed0e37dc5945d87cc0d64160e226ba886d52aa01f0ecd1c559c2977ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22316d2d951b42dc34cbe3bfa9bf90778896aa677f6a50a8bbb4193d798e2901"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d12c600333be8751b42b7eefbe760df05d4aa4bdced5ed0c0ed205f6da071b"
    sha256 cellar: :any_skip_relocation, ventura:       "48a90f5d0b0f7ac6b2b627530b9cc4c6e49728c9dbcc4ebd5ca33ecc14fa07d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea6a21d28c6837f7f94f86f2be83a42762fcc7a573f48c2f87acd7408ed8f82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
