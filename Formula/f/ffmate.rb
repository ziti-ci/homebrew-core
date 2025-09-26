class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/2.0.1.tar.gz"
  sha256 "bab3582bda85f53e66cfb4e878e44ac90cebb4b267b9bce04911748640bf323a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c69493e7fbfad7627a761e58184a4903ef4c4fd748ba1fab38e7a74bfabcc0ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb73963e3d06986cb12387c8032f955b4fb377072cc7b40c8bc5d9e275bffed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b4ab8833e77f7d509f44015fd820e89823c229d685490e245122747a29ccd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2122632868e114ac9c1c8ac28fc635f932e549f14411c55a3d0352e5875f3596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce8d996d3de942788f506ce2a4c44adb01d792c1d68c07a83f3a35130f4cb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82110b2a1ad6845ab12a0ad0a0d8cd179ae8e6c26da074e007ca2fc84796a884"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ffmate", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    require "json"

    port = free_port

    database = testpath/".ffmate/data.sqlite"
    (testpath/".ffmate").mkpath

    args = %W[
      server
      --port #{port}
      --database #{database}
      --no-ui
    ]

    preset = JSON.generate({
      name:        "Test Preset",
      command:     "-i ${INPUT_FILE} -c:v libx264 ${OUTPUT_FILE}",
      description: "Test preset for Homebrew",
      outputFile:  "test.mp4",
    })

    api = "http://localhost:#{port}/api/v1"
    pid = spawn bin/"ffmate", *args

    begin
      sleep 2

      assert_match version.to_s, shell_output("curl -s #{api}/version")
      output = shell_output("curl -s -X POST #{api}/presets -H 'Content-Type: application/json' -d '#{preset}'")
      assert_match "uuid", output
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end
