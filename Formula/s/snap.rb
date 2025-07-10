class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.70/snapd_2.70.vendor.tar.xz"
  version "2.70"
  sha256 "208c4356e17e96f25f8e5d4cc9c5494157099d15c091a530bb4f260aae9cf88b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d82bc4f8382b67f075526e79ac17a021cefffc939e3aaad472f51b191e533c94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d82bc4f8382b67f075526e79ac17a021cefffc939e3aaad472f51b191e533c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d82bc4f8382b67f075526e79ac17a021cefffc939e3aaad472f51b191e533c94"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef72b9bc99e84d5848641b89b28841e788237da62bd3fb76daefdc25eb249fe1"
    sha256 cellar: :any_skip_relocation, ventura:       "ef72b9bc99e84d5848641b89b28841e788237da62bd3fb76daefdc25eb249fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1b93d2ac358be652f29fad51c5f7b68823bd392901720ceb4b3c1839a1edd1"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
