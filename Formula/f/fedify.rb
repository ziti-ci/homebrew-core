class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.4.tar.gz"
  sha256 "ec8b75a426d7679da3bbe726a4eafbf5f53f15a9f6f82928408beabcf57d28dc"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c576ce654c27d89762675fad3ea8a1c3c7b387bf9d6cd6d662ef5c68a890f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd56457d779d90080589421a984e990df56118d49b74ff2dbc5ef14021c92e06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c670c23a9cd4f16c5157c07b669be5daaa557eeabf2c3dfaf5bd7382c3282e"
    sha256                               sonoma:        "7dfc05ebf48084d0282fea24fdf4616d5a49fddbd2c6178a54c1335a6a78ec8e"
    sha256                               ventura:       "608d9260c77b7345f4d825c8cf54a2fff30d3f566897c50223f54701fda96bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f601b9bf98f27d0980691a60258bef9c822fe73f2bc43a3f704500423e4de9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b78e4c194c33fa50b037c785f35a4b9593ff7bf70f3b6a558e7f0979b75a0b3"
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
