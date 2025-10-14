class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "e35ed3994102f81ab6c1fc294cad0f231407ca4beed8a1f46d68dff0cc75dfdb"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db754901b27e8ffad8aded9aa584b8f23b9a9a9a10f3120fc24bcb4eb8f1d48d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db754901b27e8ffad8aded9aa584b8f23b9a9a9a10f3120fc24bcb4eb8f1d48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db754901b27e8ffad8aded9aa584b8f23b9a9a9a10f3120fc24bcb4eb8f1d48d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2abc0a7076ddbb2762089a13ea06c07b6f09e619203f6efaa65736e9f242b99b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef9f6ee31b77f7d229df86308c4d1a7048dc3766dabf4171c92f9bd32bab0546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f329e366d9400cece86bae38a77eeca6750b90dedfef52a896f983a6c0fd5c4"
  end

  depends_on "go" => :build

  def install
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
