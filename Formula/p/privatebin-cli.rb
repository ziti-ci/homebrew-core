class PrivatebinCli < Formula
  desc "CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "eb143ed6d2ab88d66e615c5a98fb2c3f8b0ee5a8394590b68ddbf59bfb2c39d3"
  license "ISC"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"privatebin"), "./cmd/privatebin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/privatebin --version")

    assert_match "Error: cannot load configuration", shell_output("#{bin}/privatebin create foo 2>&1", 1)
  end
end
