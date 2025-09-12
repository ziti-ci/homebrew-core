class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "b3dcd0ac459f8f88cd71998f1d5f827fd806a9a715d0eb6430eb3485ac635695"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf057ed386834eeff6a89e9eb58f4841e2896f175c45b93354cb1cf5082c375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2f176164819e5370a6a5f3d5c979090bc7727d556676d2f8431c7bfb7ac3a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d4ce7cdfb7087b58a20040f663eeb9ac1a26286fda5e0bfa87b7a8a4f7e8a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5898efc8cf77754552ab7aad83f6d67aa8de32f7c6ea48a92fdd2fe92b1694"
    sha256 cellar: :any_skip_relocation, sonoma:        "614ddcc35c81749d3ee0bd495936695917241b445021cea14c62cd47d48ab93c"
    sha256 cellar: :any_skip_relocation, ventura:       "4263409a1240b725c2b99e1def8671fdf5883c480d9a6d794ca58fc4181df45e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e080442ea1330c09140012c4958e2a1b690c5bd267a22d587abc8caf57bf4ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2ea2683e68fd1b8f4951bf6ac5214951ed2c6ffac0f17e0cb393bc969c3b6d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
