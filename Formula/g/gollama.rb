class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "27aefaae17593eea8519b61861c98a92d78936ebf262c5906c1e1a061eadd82e"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409a3bcc489c5d5d647d735d7a6764c81b16494cddf30de6ee4cfaf4b2b4bb25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20ce130b2db9b05495ca873f08237daeb193a3d0ec51f50a9df29538adb3e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d73db706368ebb6dbb932ceab8fb66d1f52dbdba41381b7d299c5195386826b"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f705107682512afc9de1aadb8d3772792a013cd5c7e4bc81c3a86cc3f3eb1e"
    sha256 cellar: :any_skip_relocation, ventura:       "f772a875390b2680b0ce42462acb5dd31216bf647e1eae93f052afe4ff79c077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6929185695bfc7bd7da89990d014d9fb22f0c2537dadfa3f967c7e65954a9c64"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
