class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.2",
      revision: "8253ad4d2b2e7ac58268192051b92b59986c874f"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fcb8989a6aab29c25dac6785f4d196214f4b180e423ace25584ad91dfcc0103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a5196fba523cc3c0a4e2ab901313f09ba8e03731d5dbeda69e0153a3eeeb3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a80660e2a09fba0e46d1314db0ca05595405f77e66bc614c650353ab5bc92b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bca718c620aa77919116b5f177ffd75dbd1a70f2de683c7d99ba45d5ef21082"
    sha256 cellar: :any_skip_relocation, ventura:       "83383c9d75a6db92dd5670f4c5d582be0fb1f53ecf47eb1db8dbc823f15fba8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc975767b8ab535157a83e5506be0c392391cd9cf1e5f954ad1db62ac241852c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f050774b876170ef3244018fb64709c8e3cb8a173caa6896a5cf43e9cdf53a4"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
