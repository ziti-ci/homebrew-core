class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.1.0.tar.gz"
  sha256 "579beb9042fd03b727e12d2677eef0779b8d9345e96d8acec75edd1d09e495c3"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68717e54d8b1e1ba7d6fe46d6ac12da64cff1b1887a09f9245629105b443648f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68717e54d8b1e1ba7d6fe46d6ac12da64cff1b1887a09f9245629105b443648f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68717e54d8b1e1ba7d6fe46d6ac12da64cff1b1887a09f9245629105b443648f"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d638953cf9ae4dfe4f515b6ae505d65c855132c0507c8435edcace329197e3"
    sha256 cellar: :any_skip_relocation, ventura:       "41d638953cf9ae4dfe4f515b6ae505d65c855132c0507c8435edcace329197e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5566c1279664ffb650927d4c17c95abca20290120dfd05c78199bad39bf99ef7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
