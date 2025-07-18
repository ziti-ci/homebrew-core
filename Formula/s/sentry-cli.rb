class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.48.0.tar.gz"
  sha256 "86248eaf68f81843e7fe4e21f0f45a3daca1c1ef043eba2ceac3f4a56afbf6d4"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2aec4e91f82dc463eb974cc0440fcfa5dd42074a55bc037f969aaa72757e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ef77bf8d2d3d75b01883c65fe11c327cb099d200b7f44c4fd691c440a27dac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a29f9ff828cf88f9fde79ec2d53a7182e3597d5856004c8a2b4ca6eb8e8efa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed50c5367dcfd10e8bc295b0623429eb551ffdb0bdcdcc0c4c8b18c7aff6577"
    sha256 cellar: :any_skip_relocation, ventura:       "f79d7713f33ccb7b8fb8b156741b33c797f22a622004d9cb308b81f8aec03842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5070819082787c301b8b2283905cb740daaf92f48119783a0d0ec7bf69104eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfbe645d6330c3dedc30bc74b3ee395e12b4b4ab5de0385825fed08a211a38b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
