class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/39.0.1.tar.gz"
  sha256 "0ddbef45762a3a2b4b13afb03093139121422b6f73aecbf2b6655598bd98575f"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15839c94d830336c8cad7b26652bfad3cfb45fddab034457280f3b30dcdf8dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15839c94d830336c8cad7b26652bfad3cfb45fddab034457280f3b30dcdf8dd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15839c94d830336c8cad7b26652bfad3cfb45fddab034457280f3b30dcdf8dd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c747aa74e60468962030b3099687e4b1ba18e9695ed4e4daf5f29816ab7abcd"
    sha256 cellar: :any_skip_relocation, ventura:       "6c747aa74e60468962030b3099687e4b1ba18e9695ed4e4daf5f29816ab7abcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ea8ed908c8d50357634e0c839629b1a99419332ef6cf222ac601513df1e4d0"
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
