class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "9042b06e74b755aa1da81c5128f9655fc9ee68e9b58cd9dc7f9a5ee65a8ef4c2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5981311db2aaa3c2c58748f9165c4780fc2d5ed05cf16fbc3a005055d4dbc642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c15b0e944664fd551cf114a6a5d927522653660e3df21902a9929cb65dbcbc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26e7cfa3f4521231342a9ca032cc78db9f398cf39ee5fb40630f71faff7727fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e70571b03c3c2e0d9de3cedbaaef05016149ddf0959c8a7ddbb4a247987657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da21bec5bb97c5ff939f8db5dc8478910f6dd4cdb2c542b587d7daaf1405371"
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
