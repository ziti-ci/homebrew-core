class GphotosUploaderCli < Formula
  desc "Command-line tool to mass upload media folders to Google Photos"
  homepage "https://gphotosuploader.github.io/gphotos-uploader-cli/"
  url "https://github.com/gphotosuploader/gphotos-uploader-cli/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "180ced2507d796b2305627097017aacd2b0206e1131e0b40da2a46563a823ec1"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/gphotosuploader/gphotos-uploader-cli/version.versionString=#{version}
      -s -w
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphotos-uploader-cli version 2>&1")

    system bin/"gphotos-uploader-cli", "init", "--config", testpath
    assert_path_exists testpath/"config.hjson"
  end
end
