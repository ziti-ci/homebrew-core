class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.1.tar.gz"
  sha256 "6f91dd631ec630d7b558abcc783757ea189e934aee5ea645691268f859d0c197"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "799c3a3470daf5688ffd618b60d745e84cfe20c85e65091021ac1aaa67349db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c77f7b8ad61876c63da8fb21d00e5f6954566f582aba19f14b3e1bb0d832991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08fdb239a93dfa87775798a1eb4f1d395aa08a31e90a04f6243dd6d2ea78337"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1f5170503ce10eb5110a532be31a23c3ba44c211df6f685c4f334343cebf27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a03ecb3864db2a9a98390bba56f8c1531fe5c9421d96ef453deb9490baca3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b460065020e4d7f5bffc93fbe3babd6146a9001758c4cfcd58c889339f068d2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end
