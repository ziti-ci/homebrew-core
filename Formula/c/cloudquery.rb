class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.26.0.tar.gz"
  sha256 "c1000f4814b7a7727fa4b76e7c69186f11f94703283e9d16c1c3a4befa649c72"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba1e70d8f0cd28f313e6e354697ed5d856a7ff3044333dad0cc647a6950aecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba1e70d8f0cd28f313e6e354697ed5d856a7ff3044333dad0cc647a6950aecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bba1e70d8f0cd28f313e6e354697ed5d856a7ff3044333dad0cc647a6950aecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ac9799a64c8692247c9c649ce4c5ec73bbcf2cd653fa3630d63e19b25483067"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac9799a64c8692247c9c649ce4c5ec73bbcf2cd653fa3630d63e19b25483067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1557ff47bb89b6a91875d9fde351b2f80b25c3355636df3324d80a3194fcc3"
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
