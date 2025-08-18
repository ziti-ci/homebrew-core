class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "fe4ed382144aab1640f1b3ff277ba58a3b1b69b232d5ab226179b11d21f7798b"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8cf057aa57145db86871ab737cd91fe5b54a2a10030c07681efad45fcf067a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288d4e2a141cf4eab8c0bd9a01dc2167c3d294faa32c0231ed5e78b24b16b18e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4286eafe9497b18834b17c6c549b3fb31c6f81cca3ff642205e89025d630a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf7b449e758c818da21b63a05e4f97bf8b2d1509f70ac28b1a637d4f7972c73"
    sha256 cellar: :any_skip_relocation, ventura:       "aeb550e14ac621551e149e1e898c1239293162900a1a37f7aacfa7c024d240db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324611e4c6a9eab256adf8172cd080c76e99f1bb93553bfbf9f93b87c3265f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80331885bba082188d9e7e628e9938f5957dc87345fa984bda99257d51ea358"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
