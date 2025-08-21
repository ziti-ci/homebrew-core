class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "cdd411da0285a0c855f1ba4b1e8fbf7660f2fc9c3cd5bc4256c5c6e15b9a6d22"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a1a3d8d2ba0b923cb57e4ad6644f096520d1ae3f09fd4d3f472a78c0a3fa86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a1a3d8d2ba0b923cb57e4ad6644f096520d1ae3f09fd4d3f472a78c0a3fa86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a1a3d8d2ba0b923cb57e4ad6644f096520d1ae3f09fd4d3f472a78c0a3fa86"
    sha256 cellar: :any_skip_relocation, sonoma:        "67052018bda678c05a1cf14ce5c435846261473782a0a10fe26d528a5852c6c8"
    sha256 cellar: :any_skip_relocation, ventura:       "67052018bda678c05a1cf14ce5c435846261473782a0a10fe26d528a5852c6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5defe6f357b2c1bff5e47f4d8988b2ba3d874b84205014e8b4dcdb0d8df89620"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), "./cmd/protolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin/"protoc-gen-protolint"),
      "./cmd/protoc-gen-protolint"

    pkgshare.install Dir["_example/proto/*.proto"]
  end

  test do
    cp_r Dir[pkgshare/"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}/protolint lint #{testpath}/invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}/protolint lint #{testpath}/simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/protolint version")
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-protolint version")
  end
end
