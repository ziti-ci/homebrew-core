class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.53.1.tar.gz"
  sha256 "b4184411c3d30034f2d4e40311c450dde83b3fe92e9f9139c216ca48b5aec384"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5723b16d59d32705cd4724b566b291fd264e66c709252c91b12e4ffd683b0f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5723b16d59d32705cd4724b566b291fd264e66c709252c91b12e4ffd683b0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5723b16d59d32705cd4724b566b291fd264e66c709252c91b12e4ffd683b0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41a73b54997873ca9687b50a0c7f5959e124cd12e542b8dc339ddf8f61b6833"
    sha256 cellar: :any_skip_relocation, ventura:       "f41a73b54997873ca9687b50a0c7f5959e124cd12e542b8dc339ddf8f61b6833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05080007948f1dba8e3021185db3739318613ad17f617b9d099db0bb6b07d4ec"
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
