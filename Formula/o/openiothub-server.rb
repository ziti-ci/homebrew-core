class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.14",
      revision: "67772a0c993418ae771ff2c94b7e94c2040ebdb3"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b585ca31b6378dcc20282ba4b6142232ba8e8c80f5a9bf8c501408c813122c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b585ca31b6378dcc20282ba4b6142232ba8e8c80f5a9bf8c501408c813122c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b585ca31b6378dcc20282ba4b6142232ba8e8c80f5a9bf8c501408c813122c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a5d85340e5c8fd78873690450e1d58c357a8cd4747c26b7b1235fda190a208"
    sha256 cellar: :any_skip_relocation, ventura:       "d2a5d85340e5c8fd78873690450e1d58c357a8cd4747c26b7b1235fda190a208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36e99a04d07184be6e4132b0315ac0c69da68c3e8f87597ff0b56d172ac5167"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_path_exists testpath/"server.yml"
  end
end
