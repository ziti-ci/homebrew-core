class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.102.0.tar.gz"
  sha256 "75e78f96dc8ce92eacddbd0e451ec20a92da53dece7be3d5e617c207ee836ece"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f046a49ea66353f683f8be65666036806668ac56c26443e29db9d98916db87ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46145dce3f1c7d3ad5729f6613e9ed1b17d6c61206ac1e0e01bd99c5c29e2689"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af177810ab6e46280e872714db29be2fc798209de8d33a3688e4816e9a0ad064"
    sha256 cellar: :any_skip_relocation, sonoma:        "8295ef8aa4881eabb2b2dbb41c501e0d193a4ecf6422c82e6fdf996948f296b3"
    sha256 cellar: :any_skip_relocation, ventura:       "33084e80faf59bd48f9fe81b3952a4e2c875c21186d41ee33ba95d8f81acf0a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33cc67f527d19a438d6310ea2dab6fd56993db3c933e20b35dc2e8fae9b121fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce206c2945ceec3defd16d4d5c844a438b92a27fd3e86e1d211d9ab113be55f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
