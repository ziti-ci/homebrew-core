class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "e3a26599994dbab9a4f6d6fbaa8238f215b230418cc8e686bcb9043aeae3d822"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bcb25065b073c06ca91086f670ef933b7049aa9ef6f040b5167ed3f70cbc961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcb25065b073c06ca91086f670ef933b7049aa9ef6f040b5167ed3f70cbc961"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bcb25065b073c06ca91086f670ef933b7049aa9ef6f040b5167ed3f70cbc961"
    sha256 cellar: :any_skip_relocation, sonoma:        "55837acbafa6a461ff99d6865512a0ddcb74d983b3612f3cc2d3ad05ad8ff02d"
    sha256 cellar: :any_skip_relocation, ventura:       "55837acbafa6a461ff99d6865512a0ddcb74d983b3612f3cc2d3ad05ad8ff02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f177cdc635afb04c9d35b05e77da4d1e22ef1cd1cd23c53b91c006315c4410"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end
