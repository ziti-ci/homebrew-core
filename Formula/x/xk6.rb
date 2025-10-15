class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "fcb6f27d8c8458854f9d5c76771cd8633b6b0867d6092428c6ae7b5c6d880ad1"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ad0a9679d4d2712b19225c98d95d4fb71811cca042a96af96c07f39be0cc95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ad0a9679d4d2712b19225c98d95d4fb71811cca042a96af96c07f39be0cc95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ad0a9679d4d2712b19225c98d95d4fb71811cca042a96af96c07f39be0cc95"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdc3633add03f37d560c3897de2eaa425fa72a7e71846c4314285afa1ca4b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e053ec126ad23ef73e260849b4011b74cf16399fcad99b2d271fcdd2b45c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f881e000c8c544ea55c523a67f1f381fa452a92023b85abc38b71d7648b2980"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X go.k6.io/xk6/internal/cmd.version=#{version}")
  end

  test do
    assert_match "xk6 version #{version}", shell_output("#{bin}/xk6 version")
    assert_match "xk6 has now produced a new k6 binary", shell_output("#{bin}/xk6 build")
    system bin/"xk6", "new", "github.com/grafana/xk6-testing"
    chdir "xk6-testing" do
      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end
