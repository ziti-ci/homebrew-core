class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "12f4334af363086ca7293c6482426559d35471c18583dd674b547093cbdcd5fb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9720a69fbf87b51576d72ec10816517500c2dc55ffa6246eccf81d852ce20916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb006028772d4e6d170d75f586b10b1cf0eeb5d3d2ffde87833562a4091ee2ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d15df7b24ffe6606c6d29f4791945eb585b951d31c9faa38724ac8ff6ad06d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b306ff8fe34273018e6a2fb839ff1a7085456c458f96ee411e43361f7cb5725"
    sha256 cellar: :any_skip_relocation, ventura:       "bab1268a6ecc5490f09ee0000971a5fa11cfbc002e87759066507715707a6e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a769dc133f94de1a6cd2872ce4cdbb61ef5104bb1d0b746e9268693562fc32"
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
