class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.26.3.tar.gz"
  sha256 "1ccc17f9b85de742f5166d5ea68a8b3d155b1fd1237121e69ecf3760b675f2ef"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52d42765c10a77e1f580e1f80367cd4d4e2f8c1828ab416728023c11f93957e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a52d42765c10a77e1f580e1f80367cd4d4e2f8c1828ab416728023c11f93957e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a52d42765c10a77e1f580e1f80367cd4d4e2f8c1828ab416728023c11f93957e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7648da67b9951f2800d09f2a6eeee208f429a5ff382176e8a5e77173d6ad93aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7648da67b9951f2800d09f2a6eeee208f429a5ff382176e8a5e77173d6ad93aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acade446c5e8a359c8e58e275e8e429953babee347ed93591f7bb8318404f56"
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
