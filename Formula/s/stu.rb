class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://github.com/lusingander/stu"
  url "https://github.com/lusingander/stu/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "61cd09c7ad12cc20ff0bd954d6a9f591c0e1dfca6b759dab2aa2c1b7d121c18d"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end
