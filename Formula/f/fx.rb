class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/39.0.2.tar.gz"
  sha256 "ea1dbfd760f0ab664dba9bc4d49f4426b7a01f5beb70896527365321e997c57c"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf98c0b3ea511e8df5de48139fbb0998910ee921e5f8c27a92b85014d46b1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf98c0b3ea511e8df5de48139fbb0998910ee921e5f8c27a92b85014d46b1b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf98c0b3ea511e8df5de48139fbb0998910ee921e5f8c27a92b85014d46b1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33a880c2679c7671baf5bc602b22a4a537ec200f4592c53955f7d1267771209"
    sha256 cellar: :any_skip_relocation, ventura:       "d33a880c2679c7671baf5bc602b22a4a537ec200f4592c53955f7d1267771209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cf6ff26498bb53d56c415c4a333f836cad3c491418e968abf17acb49f67c32"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
