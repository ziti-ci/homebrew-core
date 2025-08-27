class Dnglab < Formula
  desc "Camera RAW to DNG file format converter"
  homepage "https://github.com/dnglab/dnglab"
  url "https://github.com/dnglab/dnglab/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dffe4dd94913a687184b2a453eeb170c87afbca62ecf3a4bc680e5f5bf22cacc"
  license "LGPL-2.1-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin/dnglab")

    bash_completion.install "bin/dnglab/completions/dnglab.bash"
    fish_completion.install "bin/dnglab/completions/dnglab.fish"
    zsh_completion.install "bin/dnglab/completions/_dnglab"

    man1.install Dir["bin/dnglab/manpages/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnglab --version")

    touch testpath/"not_a_dng.dng"
    output = shell_output("#{bin}/dnglab analyze --raw-checksum not_a_dng.dng 2>&1", 3)
    assert_match "Error: Error: No decoder found, model '', make: '', mode: ''", output
  end
end
