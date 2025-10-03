class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "524d5f1c87f497aebfcc7c52d28d5fcbd736eb086988b92344929f9e1e9c8e51"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f46627d4e9ea4b3b95ef4428ed42132a2c750c72d224030bc9c92feec06d7028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46627d4e9ea4b3b95ef4428ed42132a2c750c72d224030bc9c92feec06d7028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46627d4e9ea4b3b95ef4428ed42132a2c750c72d224030bc9c92feec06d7028"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd67ff9dcd7dab0d8e6441cb945b1fb9ccadfcbcad019e15dee07b747242c444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c8068bb0cb6a9c7bed124e90426c2223468c66ac377a71cc85a0da09715a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c01e4b94e268a02212963fc96081ebf0191d2e7d3dd866bbb1a45a804e8e59"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
