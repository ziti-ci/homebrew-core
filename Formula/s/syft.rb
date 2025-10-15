class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "71ce7642344834dc87e6277fb0121cec46b6dc0f22c647a9846f87c40e027f8b"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8868133827b0efc3de84faf73fe911f1276c67964bde68d556f17a8fb3a7c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab74d1b5c63a2ce784c61e93e3b52b00752a0cb41ee81ac1218fc3200941d6c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad55b858d0b7a49a8fac885d8110e8bc4e8ad02c92d5a1e626ec86b71bedb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "49b1d7e74014e7ecfce94feaa59f1bbe43f671ddaccec9b0ccff49d675f0cc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0680d3ac5efe1e0fa1f7db4ab7c0d54817810f2443c1e506b0dfd8d37bafb91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4040fc8fabdc7cc83b2e96d1d4cc95de6fdf7b124474c6d644a54b75296911d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
