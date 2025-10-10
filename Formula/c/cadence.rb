class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "16b30e4f5a1c6d9d5afa29799053a44306e662691451f75a2cdcca4c1c1e8828"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ac3cedb323e367bed1344967f11c7f97974098837977e010b919eac3bbb3f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac3cedb323e367bed1344967f11c7f97974098837977e010b919eac3bbb3f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac3cedb323e367bed1344967f11c7f97974098837977e010b919eac3bbb3f38"
    sha256 cellar: :any_skip_relocation, sonoma:        "17448f8ebb5d34a0c329d57023b5d9a097f0fcff053fdea9c1f009ad3cff3ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c04c2b170edaa088fb05610e7bc663b1d9f8258e3ed3a0e327d501278a18163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24398fae2b7c24243beffe78439a2949e064c8504f63a8e26c0f28e3b1685d22"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main"
  end

  test do
    # from https://cadence-lang.org/docs/tutorial/hello-world
    (testpath/"hello.cdc").write <<~EOS
      access(all) contract HelloWorld {

          // Declare a public (access(all)) field of type String.
          //
          // All fields must be initialized in the initializer.
          access(all) let greeting: String

          // The initializer is required if the contract contains any fields.
          init() {
              self.greeting = "Hello, World!"
          }

          // Public function that returns our friendly greeting!
          access(all) view fun hello(): String {
              return self.greeting
          }
      }
    EOS
    system bin/"cadence", "hello.cdc"
  end
end
