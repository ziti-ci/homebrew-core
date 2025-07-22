class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.553.3.tar.gz"
  sha256 "3fd2e2489c34b0c077a6bd39747fde24d39d9533dedacc1471d83d5a9b7a21d2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcae60132d78a1d8e6a96da118af3700db06b1ba5dc60f8def3066e4e0059123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c11c2e58940557ae4f09586855f9a4978dabaf5c4ce7dcf6ce3bf452566015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8782e0d23a92c1b1fe6ffc819226c48be851dc1d4c72fe13b855d546f6b9544"
    sha256 cellar: :any_skip_relocation, sonoma:        "444b3c3dd7e8767612709b1c9a56ce039e130b0edf29b6ce1923a92772f0b5eb"
    sha256 cellar: :any_skip_relocation, ventura:       "06e3d8ac8219f6c22ffa6711ee117b21791e1c35551e9211921354938a8fe4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a48f15e1a54be9a76776c02e37ece338a91d2c12dad11daa25affd565d87c9"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
