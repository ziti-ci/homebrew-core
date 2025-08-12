class Iceberg < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3bf2bb338676161db4896b1748879cc211ea12d9ad9ea5dd845dde12af271249"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    # See: https://github.com/apache/iceberg-go/pull/531
    inreplace "utils.go", "(unknown version)", version.to_s

    system "go", "build", *std_go_args, "./cmd/iceberg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iceberg --version")
    output = shell_output("#{bin}/iceberg list 2>&1", 1)
    assert_match "unsupported protocol scheme", output
  end
end
