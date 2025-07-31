class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "ce93943f808f0ac0c78025ad5945a3887691235d69610f2d280d2b40e6a7000e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f2636fdc7488a3bf0ac0fe9f9a7e057dd429f2d88527eae149cf42e71779ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276e4a2a55263326ecfdaff52097dd90441711b2c5c7a3e2a665de903c91e366"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78a09be73955d1401131279d4205564191fd114c009b01d44da3c9ef46e73d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8ad164ebe4a12a7eb0914cf67844761cceec49a4f21d686ff357e8c71f385f"
    sha256 cellar: :any_skip_relocation, ventura:       "c909cf93270b90db0c17b40ac507c258bd551d52ee8d937c05079a3990d76688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6099b03f715d77b7cc76ee15e0c67bfb104a67e4568b8b4a7e9eda7ef1a25244"
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
