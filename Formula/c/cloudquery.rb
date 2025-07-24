class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.25.0.tar.gz"
  sha256 "35a47a1c8e98ed067476db9304b771148f682d1dc792a7d71acabf7b81e2144e"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc8815d49913dcb599a2f2dacbacd3db47d5fb84a04fa393b29531fadf39950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc8815d49913dcb599a2f2dacbacd3db47d5fb84a04fa393b29531fadf39950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fc8815d49913dcb599a2f2dacbacd3db47d5fb84a04fa393b29531fadf39950"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21c20b7ef1b4c7eb01ee3667463f339fd74b058546acdfb1c5ad2f70b161e63"
    sha256 cellar: :any_skip_relocation, ventura:       "c21c20b7ef1b4c7eb01ee3667463f339fd74b058546acdfb1c5ad2f70b161e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51cb331fc38cd6e26ca7056619b42d517dddf8013400732a26fd652580d70120"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
