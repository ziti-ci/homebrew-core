class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.11.1.tar.gz"
  sha256 "3661f29890fe0709838e5464a51e1431f3ef1415140cfc90d0ca627d41ec1206"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3394c624973b6b3c73fe0de76c1ba64e05c91bd0f7bee064243955f13181d121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3394c624973b6b3c73fe0de76c1ba64e05c91bd0f7bee064243955f13181d121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3394c624973b6b3c73fe0de76c1ba64e05c91bd0f7bee064243955f13181d121"
    sha256 cellar: :any_skip_relocation, sonoma:        "55012f807d634720e9f1231fbd4b02ca6f5fd8c91fbece26686ea2bff37e5ddb"
    sha256 cellar: :any_skip_relocation, ventura:       "55012f807d634720e9f1231fbd4b02ca6f5fd8c91fbece26686ea2bff37e5ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3db6c13d760d1a37fc49ba46beea36f1b522318089ea15a0baf3517b60977fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=v#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
