class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.8.1.tar.gz"
  sha256 "7726d538b90e0cdc13026846d918715cf5d2dfff580fdf2a83f3b9ee9271b73f"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "701747e24e6051c120331a537e1498b743748202c92656f3da3ed8e5588a0469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5109b7a0f5418b6853229d8e64dfad44cfdcb0b37bda509b0e710275006b9dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d6dbc4e3c659cfecbea743357b5c043b4ce00c7c795d8c32b76228543821c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "85bfa5bd3d472acf0835aad26f32525b376d5404b591c9cd76a6b39db2912648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ae2a582a60a055ac3f8c3a0befdf81bfce9c96936ad0fc083770c59d9728b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e252b86130d71de0956d8ff350db00952e45e21a9e30cb76bd2a4074a280f4a"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
