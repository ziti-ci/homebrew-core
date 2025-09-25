class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "6d90cbb4a775dd83f1f56dab24e8ab8b95fb2b3cc819259cce0901cbfcc4b1d5"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c83ce84647d9a66586e7bab8a536c90d4d844e117513ab0315d1511e90ea7fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77615d47c55e6e9f95a6eee5b7613ba3de11539b7e2453ec957a9d083d92ab7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc73be3136e25e7c21d0c6a4f7363a9b54c82a94849ca37ddbb97d418678f78"
    sha256 cellar: :any_skip_relocation, sonoma:        "853e2d86f9f5eaf81ab63c3f5df2a3b0e7c7df042981eabaaa2fb9b3814cae9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a08304e62e508f8a85f0c90046c43f15b1d1e4694f66e7e5436dc28dda0e67"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v3/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end
