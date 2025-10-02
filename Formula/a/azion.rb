class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.8.0.tar.gz"
  sha256 "1c1ac08d176a7a751beb7cf931ab872be5bcc9dd277f10755d2a6c5ba33d46c0"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bdec521020505e20ab8e08526c7dafaac5c9cb965b4b35ec01ab7084c3ad17b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bdec521020505e20ab8e08526c7dafaac5c9cb965b4b35ec01ab7084c3ad17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bdec521020505e20ab8e08526c7dafaac5c9cb965b4b35ec01ab7084c3ad17b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77f695fdbbb9eefd77c4746b8ec1712912d692cf5298de8d96409678d3921c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1462983859c7380eeac62ad1bbcc2c89e9187821f7f0adff9e29c89f4a8a69"
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
