class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.1.tar.gz"
  sha256 "f1eaa6ca157c6c3fe5bb14d78cef0f2ab3d61e97c4f1908df393566d1603b4a2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec2df1c6b97dcc1ddc59e81d284a391a9f51510f74c234502b77c19a6676ef70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edfae7037790d14ee80f5b4cef92077280add01a2287192daa7ebbdcb2ca98f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5f1c74bf9d8b3a1ea158f193501078696a81beb1b601ee78e499eb3144c9208"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3e7daa1c6fcf135733f95380c1d1b4917daab15394108373c6da39a1792952f"
    sha256 cellar: :any_skip_relocation, ventura:       "60e6566522de46a1b4e18e85e3dfa1805fb784833838d974e66981529e98a1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7f2c5abe20ee93725bab9e11f3cfd6809f0622cd8be3bcd2b8f6d8c45f2524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4609cc38ad9828957105cb5fe2a662c78346db331eda551dc2ddc5ff3a53c45"
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
