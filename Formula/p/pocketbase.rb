class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "b8bd23c6fb2e12da5a5cbeaffefb8e7bf0ad1ed7fa10bafc5be49ad4ab571f64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dba878497d79bae47939b07b1e8879b78d53db0b38fe2759c24e32ed62e35926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba878497d79bae47939b07b1e8879b78d53db0b38fe2759c24e32ed62e35926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba878497d79bae47939b07b1e8879b78d53db0b38fe2759c24e32ed62e35926"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fea716e26820808330bc1bcd688171a3228040c9a162c33a6dee1c0b3426c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb422c9dc1fbfa636f350ba5df8ed5b9dece24258c77d09cbdecda58e41d767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cacc8e884d902338944de61c7aa1bd296b83e5a319a8607599a890949c5c8e3e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
