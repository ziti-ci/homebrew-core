class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "91f1c3c7f67311839a26129161676084959b3c9e4cc1ec5c38dafc7213f1e454"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1333b60b7f5c7fd393c63bc1b1ddd0465cfc904d58451b4c52b4dcb8713dcf3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f637a8791165751c15c7ef671ce4d3beb7b3d97dd018143ceeb16b42702ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "401395d44178a4247d2c242b17e1a94c18588aaa8f61207fb57f33b560597484"
    sha256 cellar: :any_skip_relocation, sonoma:        "9220168328d1024d551494c56ff7540b6b20b9ce774a8a4e0b4d3225c7103ffe"
    sha256 cellar: :any_skip_relocation, ventura:       "9094c44e815ee4c2a65e90cea6633ec1f7e4874058a03d88bafd618f7e7d466a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ebeb0aefea516a3a0f8a80668998a313f17a7557bf394d3ed29a5579dc930e"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
