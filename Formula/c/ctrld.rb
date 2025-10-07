class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "c29e367304da0d603ce4edd2fae007631656bd3d6b63fa473803dd18449d2d59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9681e34779e6f8a33d11e18bad9463c4c0f37f63ac4dc904c2287957de97545c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9681e34779e6f8a33d11e18bad9463c4c0f37f63ac4dc904c2287957de97545c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9681e34779e6f8a33d11e18bad9463c4c0f37f63ac4dc904c2287957de97545c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc6af0e66111de7fd2df47880a7fbbdd5cee33416563d3273283c562136fa29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d66d7723bdc6ddc3496d35551fdffe9b961f59a14b07fbb5a61de146f5fbc5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
