class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "4d97f5aebe0e8b057604ba695a66e2cbb1bb0e8fcf0de4f5e222096b4e93ed9d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47748be852487b8094c57b2da4e963773e5c60905f84771098a44ca23273e9ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7e4c4639812e016e0ddf16cdab8d3a5b89daf5082f027ede206ad894c3af53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "365e24723a6a5915812b26f21fc6f3492bb52f7ac4c5e92c5a3554b99fbc5c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f2ab65173359aea2a731c1d171133f495732d4913b8ca32c45d886592188ad"
    sha256 cellar: :any_skip_relocation, ventura:       "f8efe89dc6e853ba93e4db1935f1cef672fc337b165af5c93a34c61172baab88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebeaf95dae027aabe45c7e8bf30b3ebf493735923a6ab3bcd8c432cea77e69b1"
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
