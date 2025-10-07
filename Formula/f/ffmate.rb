class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "2.0.14",
      revision: "f98cd2b31d8625e33f0196feae9355fcc6bdfb3c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92408d488c711fac9b49a033f429e51fb67a04a849e71d136e9e1c273e4b4721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a86b907b2541137df07205bdb6f2c848b1bbaef68d3fd0eb4c80334372fef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbc6eef9425a692ae11e80b1bc1faf000bfb40834d31b8f6abc72d11ae6f4bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5096866c58d28d847d14b29a5fee4b971523478129f97ef8e39f065ea5dfe779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f00005f35343f7f478e2d0d0a0b959b453c6ff90a25c5c8aea60da9a550c225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e53bf04f8afa578f58524e236519a393106efaa8ba69ef15ce2a80d5b1a8fad"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    cd "ui" do
      system "pnpm", "install"
      system "pnpm", "run", "generate"
    end

    ui_build_path = buildpath/"internal/controller/ui/ui-build"
    rm_r ui_build_path if ui_build_path.exist?
    cp_r "ui/.output/public", ui_build_path

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
      --send-telemetry false
      --no-ui
    ]

    preset = JSON.generate({
      name:        "Test Preset",
      command:     "-i ${INPUT_FILE} -c:v libx264 ${OUTPUT_FILE}",
      description: "Test preset for Homebrew",
      outputFile:  "test.mp4",
    })

    ui = "http://localhost:#{port}/ui"
    api = "http://localhost:#{port}/api/v1"
    pid = spawn bin/"ffmate", *args

    begin
      sleep 2

      assert_match version.to_s, shell_output("curl -s #{api}/version")
      output = shell_output("curl -s -X POST #{api}/presets -H 'Content-Type: application/json' -d '#{preset}'")
      assert_match "uuid", output
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
      assert_match "<!DOCTYPE html>", shell_output("curl -s #{ui}/index.html")
    ensure
      Process.kill "TERM", pid
    end
  end
end
