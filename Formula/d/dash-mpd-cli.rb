class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "01a4a513ddebdc9affed8f6e51575df7b7bc2bcdeb785f8e321c84b46c94eb63"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "bento4"
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "testfile" do
      url "https://storage.googleapis.com/shaka-demo-assets/angel-one-widevine/dash.mpd"
      sha256 "4fb9ea292aba0db94ddfe8c941b8423d98decb51dca851afbc203e409bd487d4"
    end

    dash_manifest_url = resource("testfile").url

    output = shell_output("#{bin}/dash-mpd-cli --simulate --verbose #{dash_manifest_url} 2>&1")
    assert_match "video avc1.4d401f       |  7493 Kbps |   768x576", output.chomp
  end
end
