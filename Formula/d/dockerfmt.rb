class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  stable do
    url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.8.tar.gz"
    sha256 "d1cf00967f80a4228c01fc113c10348d1b69c2e7c4e48704df058b3c95093e4b"

    # version patch
    patch do
      url "https://github.com/reteps/dockerfmt/commit/5dfcd5f7afd2d04d75488963f8a15e954b97828a.patch?full_index=1"
      sha256 "8bf1b7612cd0d845c8dd7ae10f43b815a5c13d1d0dfd120d76f8deab37e9f7bc"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb388a2c9636bbc3feb066b93afcb8b4607cd530ef5394c4a5634f3b263a9c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a05b7455a8e474512e24f51d42c916f90f885f04354805d03c8b970501a44c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a05b7455a8e474512e24f51d42c916f90f885f04354805d03c8b970501a44c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a05b7455a8e474512e24f51d42c916f90f885f04354805d03c8b970501a44c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0becd9e93ae00e8821409d9763897e87cfd72c490101606bce5a8d7bcce0f1d7"
    sha256 cellar: :any_skip_relocation, ventura:       "0becd9e93ae00e8821409d9763897e87cfd72c490101606bce5a8d7bcce0f1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82bb4ce0b94d51cb2e4b921ae4116a38f2c3bd5e17e20ba0a4f1b057687610bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
