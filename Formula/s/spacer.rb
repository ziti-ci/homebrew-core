class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ab3542d6fcc5a9eccd21c81491e9cd61394d617893d5ba5f98962dc2f07094f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8a6b07edae2304af1918dbaf21b3768bd69694726ad67e89ca52edc63d53a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0622df619eb91b794f7d6163b884a1f51362cd9377b088b54e903c1a554bdfe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e854ca2740604a1d04c23a6baef9e2963caadc64a6916bc196daee8a855d83a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8826d55cb8521e68be2549b57151f51537cef7ad3861583e3cf2a292993b58f"
    sha256 cellar: :any_skip_relocation, ventura:       "fffea2973bc83ccdd9c6e81149c609edade6a31f654b513e88b735a0bb164115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a16b155d16e5531c620ac84b241d039c140ef7608fc685f41bbd6243d53398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f5c8a7267f5d41752a107cfc9608e198dddcc9afaa254ef314b52897dbc520"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end
