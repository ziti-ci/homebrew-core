class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.18.tar.gz"
  sha256 "3f43f6f2b7ceb6efb08ffc564ca07420a5d5a9ba33c88eede7f35c78c824c681"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9676787e3e87c6e50ba0efcbe91043814ab0475810adb6d85219e28afb923b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9676787e3e87c6e50ba0efcbe91043814ab0475810adb6d85219e28afb923b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9676787e3e87c6e50ba0efcbe91043814ab0475810adb6d85219e28afb923b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab37904083d800d5e7f1eca266e3d1728eb9c3cddc4c88ab478988f518a7adb0"
    sha256 cellar: :any_skip_relocation, ventura:       "ab37904083d800d5e7f1eca266e3d1728eb9c3cddc4c88ab478988f518a7adb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fd16c9e28872cdea39452a235db0a6e5cc7fa09bf7e4ddd1951a4ad5fb56e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104d02d71bd2a69e0c129ff145dbd3479de76f0af2529eb2e40edcedca9d99e8"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
