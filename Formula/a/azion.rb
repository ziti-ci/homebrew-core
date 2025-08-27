class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.1.3.tar.gz"
  sha256 "2820bc08e5adee602578932b0d693d1bd4e4423857c1ef2aee88c934b42197cb"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce44284f9feaa75f6aaa218fcaa7658883af5ad9e487c939dd5c92acd23a15a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce44284f9feaa75f6aaa218fcaa7658883af5ad9e487c939dd5c92acd23a15a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce44284f9feaa75f6aaa218fcaa7658883af5ad9e487c939dd5c92acd23a15a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0806d8d046334b0ef5a09a0ae891b8face253227490dc1d1c92b972775a23c0a"
    sha256 cellar: :any_skip_relocation, ventura:       "0806d8d046334b0ef5a09a0ae891b8face253227490dc1d1c92b972775a23c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f9aec0a41064480a0a62461280963f52769c4db7752ea935630b5579175fb6"
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
