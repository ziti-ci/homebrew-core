class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "eea2a0caf3b56b424add73a221d4316a3a1747479155fd5fba8865012c1a0bab"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82ea3e8417fe72e0f0c439e4690ddd1ce32c14f47fa32eba55e94d34ef61aea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ea3e8417fe72e0f0c439e4690ddd1ce32c14f47fa32eba55e94d34ef61aea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ea3e8417fe72e0f0c439e4690ddd1ce32c14f47fa32eba55e94d34ef61aea6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc5ce448d9ab70596d4422450cebb4dc48afe5a79846f584154888700df7273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303316a4c99047c026d4e258d3b2db4c961e1dfa03c8607fe82ee5139f954f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef7a53857e134d88cd51d0b25c7b3cbdb3c409a4a9425517505c26df9db1b3e"
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
