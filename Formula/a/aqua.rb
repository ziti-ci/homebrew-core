class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "bb173cca2a4ba5769ab0202f470b86af9f588bb47d40cad7deb8d290fce561cf"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f009bab7e33145f8837a989c2acab9de652d81d3d401f330c6beead7a657b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f009bab7e33145f8837a989c2acab9de652d81d3d401f330c6beead7a657b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f009bab7e33145f8837a989c2acab9de652d81d3d401f330c6beead7a657b87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f009bab7e33145f8837a989c2acab9de652d81d3d401f330c6beead7a657b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "d049c1026d1318dbacb09030d88fbf2abf734d4f68b083a14b8ce8644e29675b"
    sha256 cellar: :any_skip_relocation, ventura:       "d049c1026d1318dbacb09030d88fbf2abf734d4f68b083a14b8ce8644e29675b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b52372df3b0a9a44c6b33e410240b4054828d240894bb356495e3763b70ea4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
