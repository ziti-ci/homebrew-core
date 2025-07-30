class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.26.1.tar.gz"
  sha256 "a3a2ba149a17644e882fa9362bd8f1ca5456b0787905ab6f7e38c3d7738ebd13"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1c59e8f921fbcf278becc0f0f94807bf14b884ca9a7eb0ab2815d0256e1ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1c59e8f921fbcf278becc0f0f94807bf14b884ca9a7eb0ab2815d0256e1ef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd1c59e8f921fbcf278becc0f0f94807bf14b884ca9a7eb0ab2815d0256e1ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a135d874c76b2af04e21780bc616696461d6b315dd289a65d348566d221fd532"
    sha256 cellar: :any_skip_relocation, ventura:       "a135d874c76b2af04e21780bc616696461d6b315dd289a65d348566d221fd532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2deb7fb9d5c8cbfe5a8bff0b29840845b18bcff3ac512e75f4ab4470e095acee"
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
