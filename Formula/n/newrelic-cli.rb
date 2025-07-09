class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.99.6.tar.gz"
  sha256 "6e28e17e99d37e63a43032c26b3790aa6621e66328e89454e04bdaac8242bc7d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf0d199fc3c3ec5a787e16883d3ac8434d7adb603813c4f377131252ca5eceaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0c7bc4df40d77eae1c09c10ec7849068d39c4389e9b563e742f5cc25e2897c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aac00ffb3923233c0a1b176c83fc654c6e208fb0d9e817806f8d6ef679e2793f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2285390a15bb971b38614703421408d724209e4c8ee15d74ef29934c6052b7b4"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4078b339fa8b2a68ff10d9af4b34ef28204d3a4fd0e3f1948dc1819c5d50df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d5ec2b63d1234d2c0faa91a056ec00a742c814ad2b6293a04ba8e2ad698a9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c560a0bb8325945e4a52e08c723a9075cbad943340ac5a316a50b902f4eaccd9"
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
