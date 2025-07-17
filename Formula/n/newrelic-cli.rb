class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.2.tar.gz"
  sha256 "1577a39348be7fc22355804732acfde5fce0c66f3d0b3fe5f24b287639272634"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e8cd03d46a478f1661a737e3bc59a8936f4701cad005fefc1afe385b9062dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abff31861a487ef7e71b8be60848f9a92427a63d9ea61d6192da0b04957c3c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91a378c8bb3999fc9b4d9c3e46cbe1cb8624a8abb21d1e82bab8c4cc25745551"
    sha256 cellar: :any_skip_relocation, sonoma:        "296df73c6521a5a39bbc15d9524e4bfbc73a0abf818d9432e68e3fd463e1c8fb"
    sha256 cellar: :any_skip_relocation, ventura:       "8f8cf02487669019e63af958c819dc43061d2ef9dba18edfa104c3f19e450039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f00e05257dd0a8ca619ed26642a928f41e451bc103aeadf686721c71076d76aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26dfee6737dc8e6d9d7c571b04e1e2bd1bb5468d11f8f60172309bcf1e2f1f2"
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
