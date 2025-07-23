class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.4.5/traefik-v3.4.5.src.tar.gz"
  sha256 "4fbbf905d65ac647be5cc5f9471c9d72feba829018f5331fe27ba05afbaa494d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4af8854e2d4f792c7f2a428c3c2ca337c72df21cb8e274a6fa0ec3a4c23ddae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4af8854e2d4f792c7f2a428c3c2ca337c72df21cb8e274a6fa0ec3a4c23ddae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4af8854e2d4f792c7f2a428c3c2ca337c72df21cb8e274a6fa0ec3a4c23ddae"
    sha256 cellar: :any_skip_relocation, sonoma:        "02da109793dc0bd513815e617ee88c9970a1d13bb552ab89fea5b10bdefeaf4b"
    sha256 cellar: :any_skip_relocation, ventura:       "02da109793dc0bd513815e617ee88c9970a1d13bb552ab89fea5b10bdefeaf4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcacb4fba11115f04a2c7685fecae6ecb04dfa677e3814d7770787760a5ffd0"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
