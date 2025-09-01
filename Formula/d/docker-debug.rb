class DockerDebug < Formula
  desc "Use new container attach on already container go on debug"
  homepage "https://github.com/zeromake/docker-debug"
  url "https://github.com/zeromake/docker-debug/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "5b7682acc6dcf93d9d260de88c269657348c4ef6db1ef184d794786509ba0af3"
  license "MIT"
  head "https://github.com/zeromake/docker-debug.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/zeromake/docker-debug/version.Version=#{version}
      -X github.com/zeromake/docker-debug/version.GitCommit=#{tap.user}
      -X github.com/zeromake/docker-debug/version.BuildTime=#{time.iso8601}
      -X github.com/zeromake/docker-debug/version.PlatformName=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-debug"

    generate_completions_from_executable(bin/"docker-debug", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-debug info")

    system bin/"docker-debug", "init"
    assert_match "mount_dir = \"/mnt/container\"", (testpath/".docker-debug/config.toml").read

    assert_match "\"TLS\": false", shell_output("#{bin}/docker-debug config")
  end
end
