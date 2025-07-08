class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "d9abe3cfd7126eb0e3c4237bef7dc88d1ade00b6b3086aabaa60a489fdb94e69"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ef39186c62932bf230307256b9732050ce097e5edae4d844988cc4edc4b889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09aea008554439c2386a7b38a79280865b1eb8cee0ed462c669a2fdc0bb0e35a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "944f60076ae1cafa7c31f285e358ceb597d6ce58575079ba9c16525ce44672a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3ee4d30f50d80b3bd1f7c5c89cd50ba95573dfd400c6073f127dd156372b3db"
    sha256 cellar: :any_skip_relocation, ventura:       "08e1405ac753f3f665502b5521c4b8f07473c692baf944462c823900d5dcd33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0db2025774562ba58500e98ae30afcbf6b0b6f02a03b16c5a1481b1a39b6e2"
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
