class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "e735eb9e568d5cbc23b9ed348f36a5ae8cb05b649f0608a2b5da9af0a665f3c6"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355a8974c61c14cf011598283993ab8a71606af6d47e7052ac62c4aa0da7b172"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2eec557781e7e3be33e0759948bb0f966a516a9a006ad10c9c6b98ac1c4dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2eec557781e7e3be33e0759948bb0f966a516a9a006ad10c9c6b98ac1c4dea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d2eec557781e7e3be33e0759948bb0f966a516a9a006ad10c9c6b98ac1c4dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "750ac51f1a4498e535b0f5b260cc48ce0af6c8b93239495dce1d63a2704400c5"
    sha256 cellar: :any_skip_relocation, ventura:       "750ac51f1a4498e535b0f5b260cc48ce0af6c8b93239495dce1d63a2704400c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0c86967c62296e73071890e40960ba1e66ae09eb81efc37d23b4cc3c481a83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
