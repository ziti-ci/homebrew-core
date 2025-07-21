class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.6.tar.gz"
  sha256 "0f0fd7b2287ae2734d1a114c20de825921001da94e885792224568c39f8c16df"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd97edb29505ebe5381ca7940acbff34a876b06e50a0d70118c74ff4e476c367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd97edb29505ebe5381ca7940acbff34a876b06e50a0d70118c74ff4e476c367"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd97edb29505ebe5381ca7940acbff34a876b06e50a0d70118c74ff4e476c367"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c27b12a1ad7a3142f7a2daf8afa1a41c9f4685d513772c2661850d45d83d227"
    sha256 cellar: :any_skip_relocation, ventura:       "8c27b12a1ad7a3142f7a2daf8afa1a41c9f4685d513772c2661850d45d83d227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02143847298fd06c6dd49fe7ef3cfe69324e7422edd174c6c8c55fb3c3e8769f"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gosec --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
