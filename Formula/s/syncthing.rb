class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e5bdc6cbc9d671d6c1bfcc0c778bd4d591ebb491fe07d5f7a1c19916c8742df6"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc197508bc3e117bd0e4f9ba67a8568592f7312c48afb9b8ac06caf3bfe527a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f65b5c0a4f83df1b1c23fcba1cbb777afbf21f7222cc94d04cc4262c9802be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dec07dc21486f80e4b3b95b1e99d9f01c32f68a58ccea2d474991f518844b43"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3c6e925f27d066b4d25e57c0435965d71ef3e4cb47d40e10cecdbec6d0ac6e0"
    sha256 cellar: :any_skip_relocation, ventura:       "b7bd3b76d5f971a501bd456c83a442698af40ce875543d9b76923076ad5709e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25650825c7f397fef52c6dc715d5a983a203caa473948396eff60370946f2ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079bff0cf3a9561dcf07e517eac444729637c60770db723b8c0d6e8e0024e0de"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end
