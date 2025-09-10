class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "6a88c95ce260c45fe9bdf49a3286db72e4fd3732a873676d551b777407345acf"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcee897f215dccdeae2cbb5d7374254718d865920ce6b418f3b0937df14360ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcee897f215dccdeae2cbb5d7374254718d865920ce6b418f3b0937df14360ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcee897f215dccdeae2cbb5d7374254718d865920ce6b418f3b0937df14360ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eca3d8a9f281abfd24195444704e50b16dbdcdff52011a2a7180c3e0e6c1eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "7eca3d8a9f281abfd24195444704e50b16dbdcdff52011a2a7180c3e0e6c1eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943bc566fb3b479edec89dc592ef0142dd81c4c53435e2223cbfff7c5f2cbf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324121c4310c2c457a15c405fd9649052ba97a9c2017b08698a92afc4d01abb3"
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
