class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.33494",
      revision: "7cc65701e3bd9e1732fe5e449b5929f1e5f04618"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8685c4735df68446ee7e7b80e651235666d0a40f9dd0576c73bac4143168ca2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355fda1df4fb9cad12b36b55b96478f0f58c110f694f64f4df59a4febb29182a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5f0806a8840e2014110350ab3d8b8240da3f9a25e1fa3fe5d20d0f0780afcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef4afe2d769d91b38659acd5cbd224637e7d0650f25f7d8d27bbb3b0b024ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bfda8c856e01b27607399a6b3623f6b9a9370bf9ac1df9956e0b5d40e6d13c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
