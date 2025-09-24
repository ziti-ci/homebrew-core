class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "38cc487db8b86a1c811701f99c5932f0c695c979743eb7f9c000699c5f64fc23"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8302a9525c2d2f04ca2fdaa1e76a9fadb72a605e607d919686f96b6980bab612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8302a9525c2d2f04ca2fdaa1e76a9fadb72a605e607d919686f96b6980bab612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8302a9525c2d2f04ca2fdaa1e76a9fadb72a605e607d919686f96b6980bab612"
    sha256 cellar: :any_skip_relocation, sonoma:        "51971c1d843e034bf360cf35036e48e92c78e6e81e081668d5a9610881c145a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620f2a00cce7885461cbb7036039672c3a7235313a3a56f43db5f8ae240d1ac6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
