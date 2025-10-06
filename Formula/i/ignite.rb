class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.4.1.tar.gz"
  sha256 "be80089add623fc31219cb8e3df322a6db5325a1540d186ad3e87421335e6270"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fe41e640e6ce1c160b57fadb2a15ec27cb583ecbc9368bb6bf771c9aafb298f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5803810d8fae6a7c75ad6c51035926dc011f907d11e2029e97c41d5e5a4fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8cc6394d55081f1e3f612bd9353a48b08ccba7644a2f5610816e540a160f5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dc287001d30393bbdb86d789ae4afd8248f645b3f4e5f80903427fd22de532b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2354a861f73b7103e17117f3df44d6d9887c912ecc99317963303f2da36f64b"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
