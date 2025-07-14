class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.622.tar.gz"
  sha256 "277eb2b3419aa9274877a781891b0f8475d5569e1226dce14eb8dd8209125b36"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4799c5578ab48a6ef58161adb1cc67a4f237622a3f088c39365e68809c650c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1747350ac301937ff4d5d61bcca60c39720a46980f64783f798dd985e012e13b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8eb9693386161cdfd726868dfc09195557573718b5ff1063f3e0d69fedc043d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca060535eba7b153690de978c5863f02066918c14773082bf94a2da9c510224e"
    sha256 cellar: :any_skip_relocation, ventura:       "e88de8770a1617140fac697942afa41bbd61cfad1342a8e696a959aa9642fa17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cede7b61d668fac205a0add6266769f86aed924f5437bb30325307edf58120b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba02dd42f62dde7c84888422c7e904b27f6374296113af3519a831112d3c314"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output(bin/"ipsw device-list")
  end
end
