class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "34926f5c736544b0c754a1a6de05c2ac3338033f77e872a2a4bcef55667e7509"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30778e05effc52be9314a34841858b4e459997591221e80e58c0e3d8a16d70fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30778e05effc52be9314a34841858b4e459997591221e80e58c0e3d8a16d70fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30778e05effc52be9314a34841858b4e459997591221e80e58c0e3d8a16d70fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1efea3fac8b4298273b0b56a1c8c37421ce584375c4667caafe4abef0bdd3992"
    sha256 cellar: :any_skip_relocation, ventura:       "1efea3fac8b4298273b0b56a1c8c37421ce584375c4667caafe4abef0bdd3992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb178e1109065afed2d01014e8de942057445f90a34e2b1a370acb885e23800d"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
