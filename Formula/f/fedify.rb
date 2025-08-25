class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.7.tar.gz"
  sha256 "0ef8d220200523c1ed7ef86b91743992ccc5614307f3412c527f511c47e7dadb"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a5bc9924a99365c9f27b2ee5d0d2c9011349e95b569d092b41614c84078e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5304e6cedd604be026156bb10bbec51baff879b5b936b7e4e0a5d61690050aa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "250c47fd5c33e637c3da93c5e9ca00e90053aeb61db7075123104a831e6eccc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b3d3199eb063eb160827504ff7596de22fbf6acdbc1044fdde9b65121ef9df2"
    sha256 cellar: :any_skip_relocation, ventura:       "9195ee2ba8b13855291ab3ded98f06232f70cb7a9105c4919898d4932750845a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30399c88e5c4619094017f32b3bc768206e7b6ddc5f8fbbb8090a9d2fb22dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba104172e743121d871772d355decb3c2e72afb930b00094eb786ab26890d39a"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
