class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.137.0.tar.gz"
  sha256 "2ed126e68e635063bc757d79cd17c493066997a8625b5b019f5b47fad58bcc0f"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0a5f0e7adaf4802cdb786399ed91e33b41acea5a8c1513683a5a56b6634795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0a5f0e7adaf4802cdb786399ed91e33b41acea5a8c1513683a5a56b6634795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da0a5f0e7adaf4802cdb786399ed91e33b41acea5a8c1513683a5a56b6634795"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ab21875f68b15c9656318427ca561bad0f71b62b049f7fa81384669f9f67bd"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ab21875f68b15c9656318427ca561bad0f71b62b049f7fa81384669f9f67bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff794ca3952585947b6725e6d8b1d7d5489025b1be85d7fad0bb2ab6b713b7c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
