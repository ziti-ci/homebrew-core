class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "e667e4ed6651cf21fc89e11a9c06deab48bc9989e58bbab50acb2ef0f0f739f0"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22d1c159f0991a15523b0d2f91e870edde82f05eb3f1d53a4b631d7eff2827fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2b14d638f91795c3ce5b5bacf12fd702f6286aa462cd70cd85f66954c60b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7689c259d9cefafcf160041323a0ba9c00e8330793657846f700fb492d24da69"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9356a018dd2ac3331198c14d1208af65292ab2c862c3bb953e97844f832dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9917f0df194b5ba764f033828ce16b5a8bb6957d95e07c85710009207fff5147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba70fa72d47bed363da6e352b3c186e600565745a339e901b3c6cf89083bae9c"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
