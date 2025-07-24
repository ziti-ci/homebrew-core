class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.24.2.tar.gz"
  sha256 "81e39e74419a4c5fed431ecec5c5849f91ab18cff94bf0b573296d48a0fafffe"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef25aaa07c2f8683bedc9258e0db1e8fcd66df0815ab624515413c6acbc70d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef25aaa07c2f8683bedc9258e0db1e8fcd66df0815ab624515413c6acbc70d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef25aaa07c2f8683bedc9258e0db1e8fcd66df0815ab624515413c6acbc70d82"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a02da53ecaf06670b2e35a9c0e193e78747a84fe26d11fb7cbd186dc1c8887"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a02da53ecaf06670b2e35a9c0e193e78747a84fe26d11fb7cbd186dc1c8887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb09aeb6bff7a0b26933e18e201c1b173e845b59e5809bf1058c7fcb3b6d72e"
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
