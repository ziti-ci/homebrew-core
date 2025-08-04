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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae47c461ffcc826396a9e8da8aabfaf87fa864a6fc008861766fe5ce4d33d0c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d917ba6f32c7df685d0c960daeae5fa9fd0c15d5202c11711ff6a659d6274d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf61bf0628b164c71134373994ebd87d83de0983068cf4b2e14afaf4ee9e29bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2001428470210d7fd53d19d4a9a63fe3dc3247731e8bf5bd3c7c86284f3fc2ae"
    sha256 cellar: :any_skip_relocation, ventura:       "2cf0398ec636c07b42f09b4d333ba9785937679df8c3b951263fac3ea9dab61e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4ee178f093c3028351d50bd3b2e8802aff39ccf2c5254c02c7f8c1a11d50139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11481d6d21282f837f36675e986bdd8a0c937decfb5d45af49013a9e317519b4"
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
