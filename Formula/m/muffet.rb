class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c54af3f50150d7a58d83d1d33b98a489f6bc0d0290887b3ae18e6677e08e1737"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44df4d1456f7aa3fdae7fd9694a8e1174a79bcb29de7116739e856e1e05b5f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44df4d1456f7aa3fdae7fd9694a8e1174a79bcb29de7116739e856e1e05b5f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44df4d1456f7aa3fdae7fd9694a8e1174a79bcb29de7116739e856e1e05b5f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4236f6ad7f7533df8e4d3aa833bb2e992160b63d5834211b9806263a55e4250f"
    sha256 cellar: :any_skip_relocation, ventura:       "4236f6ad7f7533df8e4d3aa833bb2e992160b63d5834211b9806263a55e4250f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a188c71114cf40e552dd8ba765852326d950f1ae762f7ef4955fbfecde20623e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
