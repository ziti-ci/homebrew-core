class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f44feaa1bc150e7964635dc4714fd86089a968587fed81dccf860ee7b64617ca"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
