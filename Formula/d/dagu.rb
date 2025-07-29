class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "4ced90dab8445c4faf8aece877b11ddb8ccd6aea087a08380228f88cfb3a3e94"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "544a0733f679861a503c1c419bd1c1447b7dcaaef4b4828b422afb0626e959b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb10f0ebc892c24c0cf28b8e30605679cddb04e876c09735e70f9cd23067e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16aa0de675ba145c8f0cf9828381cf78373b4aa0121672b237ed4a37af30e7bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "76be9bc4c5c85a08586a395653d7d3062637a7d3c0a0c78c15fc686f6603f762"
    sha256 cellar: :any_skip_relocation, ventura:       "b89be2b45789b82e897c65c62d56c5a641617738a7c2618b7faffe78d14a7347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e2372e33dfc1da2231e33b335a847e3c77bf04a850b4c416aca0c564072e43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "The DAG completed successfully", shell_output
  end
end
