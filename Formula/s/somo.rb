class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8026a39058a0e71cc603cd887b4fd5c0eb8ff310fb5ee1a36ff98ebe90be5878"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end
