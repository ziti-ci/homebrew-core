class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.35.tar.gz"
  sha256 "5e5ff9a8c93b207572006ec94d2ec334ef40ab61c62a1ebd4ed15f7ba75ce8b6"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e2dd676fd034e3fc92b8c6e1de4aaa02d041b5765bbfe47144ff6750cf1b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e2dd676fd034e3fc92b8c6e1de4aaa02d041b5765bbfe47144ff6750cf1b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0e2dd676fd034e3fc92b8c6e1de4aaa02d041b5765bbfe47144ff6750cf1b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5502eb03338a5e8512ae3e7bd159883343be9142494ac2b26450850a2d196c"
    sha256 cellar: :any_skip_relocation, ventura:       "6e5502eb03338a5e8512ae3e7bd159883343be9142494ac2b26450850a2d196c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6162a36e47e0ccb79622696d7cbd3bcd2971a84555f5f81f69aad6e1fc9f8b3b"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
