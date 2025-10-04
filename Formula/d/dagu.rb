class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.8.tar.gz"
  sha256 "e5aa1c4115d27dcd3ded0af35b27202be9c0aa42a5d7e6b2a5735f709caabcd1"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eb88ce44c76b3fde9ed883b522055b315d4ec40a31bdfa81e2401b54ee3e29f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2546d23cd1fb6afd7ab44c7938f0e0d7fa16654f90a4dcd22e1d06142e00deda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d8608f6dc9de0be866e920b55551bf5223f20c298ba2911460983ed547d8e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "193e2688ab58f94ec94a2666169113ad4cd247ccc072afc78f65bafe6b24f9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4f57ffcda977413dc46e01e0ffd3217d4583f1146fcac094131c5d4e09b7f4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
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
