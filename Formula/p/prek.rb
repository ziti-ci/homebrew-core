class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "f47105cfa938896b59e5afce0fac862e2eb00989c9d93d1e3625cf9fe6cc2cc2"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbabe51892fad507b80f28e9c08eb0078963c957d39019f53814684c66824eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abff102e3374c19977fe469f3d5fb85c7fc1264d1ffa6f8f8d1e31d59bd1baff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6b6c2004b500662fe10a343828f7aabd21fd1987e48f879f06a2eceec2fd6f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e60fe41aa9454991955a6381de2becfd5b0654f6dd83ea3111d7c91a4c2e8c03"
    sha256 cellar: :any_skip_relocation, ventura:       "6dbf34913911028debb4e5931fee03bbb5a599e1a1be600844c46d9724036377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d1740d89ee12b68d1a86a9e05cbba340af308176c5cd9670573f553bb56505"
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
