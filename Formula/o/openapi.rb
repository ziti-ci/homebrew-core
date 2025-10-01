class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "3c0869580484250d358b4f978864642c6a992b37ce8ec212505739c808ab72b2"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c809e3d7dc72a09166b51b09a50f2cf4ab6a5e042aabcf5a87a33b0e7a70873a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c809e3d7dc72a09166b51b09a50f2cf4ab6a5e042aabcf5a87a33b0e7a70873a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c809e3d7dc72a09166b51b09a50f2cf4ab6a5e042aabcf5a87a33b0e7a70873a"
    sha256 cellar: :any_skip_relocation, sonoma:        "738783cec372844de605a7a68cfc3332dd2fcc09f426b8d741966726dcfa1695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5576057759cc44031a8d5aa8b73181e932518c2ed2722eec8eb9e9af65b92f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af88e3c1f2ff4388222bd843ea0cf83038a29be20aa497beb1967f06ab20e7c"
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
