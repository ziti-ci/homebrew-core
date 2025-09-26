class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/2.0.2.tar.gz"
  sha256 "b9293ae653e99f0ba5a727b52541797bfb8cbafe5cac13187b5f92d2a9a4cba6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8c2764b474faf4e024014403065c254497f19d24b5723268960e10d49e57fdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a8c95c0f68f0a08a729055c155e16a7604efeb239f19a0d7d1515f5516289bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bae451011378c7d731a4362283507012ed6725cd7e206d3eac4cf3c3ac49ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f7862f2620b3ab57d481582bc4b48a698bca07a382f66b12bb6619667b4e3c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb5bbba413532543f00ad329d385c82a6161a3b074ac498eb0b1dd00475798f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f28330f51d66c2ff8ef225b1206960b809c7f786e3f0b9b565eaf59e2affb8"
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
