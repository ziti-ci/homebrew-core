class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "2ac9195237f2628f12c954f68b796855d18e3cc1e1c4ab77139fc1517c5d3a30"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "048bdae97e13dc87610104b53a192cc415d24020076dddfbe1e4e91fecf0f0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206eaed2f059dcce5944d412e9b5a5a6ab4f45685668ac3ae3db2123c9790dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "861e3b592d7cc415cbc31a1436a0b4d1a1cbed7458bd32c734162d2877e76ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3345a71ebb177f9eb89ac86b9093a4a83c6170e2445a903436ac3de72a619f1"
    sha256 cellar: :any_skip_relocation, ventura:       "166eebcb0f79cc852171148bcb6512055dfad06881c40f5acf6e8cb5f48722bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d5ab94d877d09aa1b2bdbac0612593eae47fbb8ca1cfb340ead2d626bafed7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e92a7fa73656ba8546265a2688a6ade006293a193888fe7a8c42edc711be616"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
