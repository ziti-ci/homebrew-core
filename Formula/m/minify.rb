class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.23.11.tar.gz"
  sha256 "d2eec8d7d5a713476d4eea491c3b0da0d9391721eba6e71b00d5855d26cc41dd"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063415e1c4a529ce1d071d2f09af534d5d8843835aa01be0b31a5d8c1c6b7b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063415e1c4a529ce1d071d2f09af534d5d8843835aa01be0b31a5d8c1c6b7b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "063415e1c4a529ce1d071d2f09af534d5d8843835aa01be0b31a5d8c1c6b7b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "39bd98d7cd9a0c7a0923066127403617d62e80cf622abb528b2da7782150049a"
    sha256 cellar: :any_skip_relocation, ventura:       "39bd98d7cd9a0c7a0923066127403617d62e80cf622abb528b2da7782150049a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9266fd007fdf8b9a61a988854ddd49ad522999ccfa888373f916e21a859ec0"
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
