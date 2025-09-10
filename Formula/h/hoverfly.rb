class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "499d2e17868095641606a8504f23896759792863e3a8525bd6e663354494afb2"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce2056dedd36396ebecc48b10892174de50b8ac36386b7a5d7eafe060b04dae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2056dedd36396ebecc48b10892174de50b8ac36386b7a5d7eafe060b04dae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce2056dedd36396ebecc48b10892174de50b8ac36386b7a5d7eafe060b04dae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d15dd03eebe265603f8ff1d6d0ad0fb865a107a4fae2760b27514fce82357ca"
    sha256 cellar: :any_skip_relocation, ventura:       "1d15dd03eebe265603f8ff1d6d0ad0fb865a107a4fae2760b27514fce82357ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43704d42d48b516ef14b83ec9716c71d10e7c7733949ef6208fc93d83e7ca9f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
