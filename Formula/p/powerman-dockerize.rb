class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "4981d4128f2e156d5fe27a7d6ac7b9e70c94ffb8e9cea792e7b18d7fbaa4499e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f7815cb8f54e0eb4cbfc2259ff64f823694523de8cc0c5a365cf57c0cab7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f7815cb8f54e0eb4cbfc2259ff64f823694523de8cc0c5a365cf57c0cab7ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50f7815cb8f54e0eb4cbfc2259ff64f823694523de8cc0c5a365cf57c0cab7ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4a558d65bafb4bb4a8e3dffde25ff31e4418e0b8228eac9982e9a29ffdc701"
    sha256 cellar: :any_skip_relocation, ventura:       "ef4a558d65bafb4bb4a8e3dffde25ff31e4418e0b8228eac9982e9a29ffdc701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4735f34ed9652ce129ca4bc91094fad060ef72cf0a5a08226944b4653b3706a"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
