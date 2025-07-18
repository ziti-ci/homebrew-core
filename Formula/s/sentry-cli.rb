class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.49.0.tar.gz"
  sha256 "5042c0d7a448cbb6a282918dfaf40e7e5989c3522fb5c3eaf629cb8ded2cd61d"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f13fae9acb05f66dd034beade3d78ee011403ee3e7415ec23096e5ec4525cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0d5ec51b23ef69fdbf30c868c9154dc7a3e7e2e7b15a1cd258ad66905ca4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c42c471652f66300fac100aa8da8a7bf3e17f02bc91c0687f9badc114d55454b"
    sha256 cellar: :any_skip_relocation, sonoma:        "419a8c4c9c841c88f0cb99ec5c53e82a5698709a99cc264ca56a7706000a37d8"
    sha256 cellar: :any_skip_relocation, ventura:       "cca2c13410ed9fb473e39f37b536198ab78a6018e3bb01a6dfa84aa189b8c726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44dbfd0fcb5cc7fc0211bd8e2a12f67cd017fe3724c0135d496ccabe4f21d53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be021ecb4e8284be76e78b415e1be976962898caf0e874176bf38e546e5aa0a"
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
