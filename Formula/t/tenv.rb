class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.9.tar.gz"
  sha256 "36ff5f53078c53b93a401f9a8fb56e04107ab9af9b4552c515d0f16902f60779"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78113e1b51bc5df2b50094b75db6571feb3be14ddd295630a4f77b5373a6f6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78113e1b51bc5df2b50094b75db6571feb3be14ddd295630a4f77b5373a6f6b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78113e1b51bc5df2b50094b75db6571feb3be14ddd295630a4f77b5373a6f6b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "557e779f535c0639d42b72d92a29219e5419f2231bd89530d8cb4b83abd110f1"
    sha256 cellar: :any_skip_relocation, ventura:       "557e779f535c0639d42b72d92a29219e5419f2231bd89530d8cb4b83abd110f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3530c6b47d38785f184bd50a34a407b81f867e8a9478fdbcc6281178bfbbbb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa630d10a52d8e8f053e47c7296eb1fed12114fb9ee8238fd622413696869bb"
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
