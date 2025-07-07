class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "3cd1ccc97c5ee1a0e039ee5b4f9054718c8da64861f3086e24d98e076f1b7bbc"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5696fd9a1c38b0c9c1c05e295b76a1f74a2e9ab93481284918fd73455739a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ce9377abb7a07883abdb6a6e18eee85b8d32cce00d6d2d7f9651f7c72f5054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9bec79d2e38a846dcf91cf7b089cddef4aff614e3e0c390c35f4edeea9d2aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4adde845f85a138a86cd81ed1ccf01317e11bd95bf902a8993f4c96c4126e5a8"
    sha256 cellar: :any_skip_relocation, ventura:       "e37d18c74ab6fce4608de55ba0f7418138766e684184ccd60f903af18aaedcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff80f8a0db89cb78fdfcb6135f316559ade96e8a5f8d16ccb926a069a70f111c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/v2/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/v2/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/v2/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/v2/info.BuiltBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc/"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin/"gateway-go", "-c", etc/"gateway-go.yaml"]
    keep_alive true
    error_log_path var/"log/gateway-go.log"
    log_path var/"log/gateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_path_exists testpath/"gateway.yml"
  end
end
