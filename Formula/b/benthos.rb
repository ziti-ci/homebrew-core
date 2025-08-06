class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.55.0.tar.gz"
  sha256 "23c553706f357ff811670a4989ded281db0b92e5cbd1551a3b6e78ffa22806a2"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86cba8b67b8c0ea4c76826a6ee710571cee39a10e4944f13410d24cbab5d534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86cba8b67b8c0ea4c76826a6ee710571cee39a10e4944f13410d24cbab5d534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d86cba8b67b8c0ea4c76826a6ee710571cee39a10e4944f13410d24cbab5d534"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3cb47848907d9ad9962d3802b802952893f2a7d2da2434cfb5d8ddb3362e62"
    sha256 cellar: :any_skip_relocation, ventura:       "cf3cb47848907d9ad9962d3802b802952893f2a7d2da2434cfb5d8ddb3362e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f4eb0ad67df6fd9ee27089cc15440a99b170107ddacf383a1d9d81b2fb3be7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
