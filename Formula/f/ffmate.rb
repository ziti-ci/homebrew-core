class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "2.0.15",
      revision: "7623e465367bc09fdfdc08ce6b21b7d6de1999c1"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d276c09fdf283bda6fbe550df618744822a610e104c69e448b2ed7929105a09c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d9bc2358b8bb26e6b63cd00ce6b86d15c546afbfe78dbcf21744aaa669cb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b0caebd4c34713ad0dde23e7bead63adb0d0d975b11fc330e30eac7adf5d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f031027c60679381df632f0ca48333d7cd6f0657072617f660bfa6b99b7d392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68451e9a696c37a64017719bfd1bca60d085f4735fa3dda87abad7b7d94bfa7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292ad06df240b1c00213af474bb5c4bd58bc9d2345b721a0461bb4f5e039b8ea"
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
