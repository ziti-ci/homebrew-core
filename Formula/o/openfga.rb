class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "8ffe3b56a872339672a676e9d8a701f16835b9c6d2df0e2c97edf37b6cd2ab09"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dceb5fbfb0299437890d10c2f91fff33b16c5a7a2da62212d1450c2335cd36db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4e830134944e3d51ba51674c6f401c3cd21f5ad864728824cecff407442f2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77c0868e9fc8395a12948f06ab8a8fcb5b9506c53ab8d5e1f07bb179ef5b6ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "daa65275a94952771ed59a9bd5632f9b5ebeb046549513dbdcd04fe8c6748d26"
    sha256 cellar: :any_skip_relocation, ventura:       "910994427021ac2ada9b6b5a90bafdd0cd2b848a5a255cfcfe0bc95f8ab64f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80f152e5b6b2f78e0310356bd31a020fba6f98dd15937f19479262eb2de69bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
