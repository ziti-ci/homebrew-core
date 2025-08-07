class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "299d2320e8f6adb5b53fb1a32e613b00cd2263237c2c4f8f3a68885040b2cfb9"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2188d04e9a8e5f5d72a1a4334b0470b02adf395981fbcd8df0f67948ba985409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2188d04e9a8e5f5d72a1a4334b0470b02adf395981fbcd8df0f67948ba985409"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2188d04e9a8e5f5d72a1a4334b0470b02adf395981fbcd8df0f67948ba985409"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65b33ea753b054ac7010689649a95c16ec14010d52d2f66b5441225958a9c1f"
    sha256 cellar: :any_skip_relocation, ventura:       "d65b33ea753b054ac7010689649a95c16ec14010d52d2f66b5441225958a9c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721cabdd130d47ef28f9610633302eee019aab0bfff84c9e4e2838acdf61aeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52472ca99dba22a11a17ff8283774a210b35ff2565a20d8759e8e925a7ec5c4f"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end
