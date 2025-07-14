class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.46.2.tar.gz"
  sha256 "623b431b196368d720c79130f879f4f9c223c7fb59e387ef4dcaf6af0ec15d6f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ad66a8e3dc05cc4e2d1415a03148f106f57beb7e25dd034b2aa49ec204413f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e45516a79f42ca14d32c7b9026d769b69733c2325338224e4d7f7477b3ebb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae710a2a6bee164b2c0dd4874419d22b3687b8c4675d12421c5e489177d1cfd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3e23225ccc3caa3ea70597f041b512bc35bfcb6a808da99b511c5bb9597436c"
    sha256 cellar: :any_skip_relocation, ventura:       "6940e30acd81a59bf26e0dea52a8e50d9e59feb94f0df1cf7e2a8e19720cbdf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785978bf0c5ec01e9ed5184281cf0d3300419c8375d3440ecb4211e6e6467511"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
