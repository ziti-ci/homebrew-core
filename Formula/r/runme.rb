class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "62318e0ca5bbb20c6cf063f35cd9f61258740639f9285e29f84c6eb7a5dbb712"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "522fa4bafdb65f5523aa3ddabb19c78a1d5bd0b73b044d7ab3b42580937a9db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838f5b1a6de16dc6e982f05c2fb22947260eb12fccb4d71ab2449f50d8b9a510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31e2e17f2ada8743b72eaeea936e823a8cd0e4a2bfc9252f35d10aca80f7105"
    sha256 cellar: :any_skip_relocation, sonoma:        "178d08a70e1de6a1a574c834dfeb922e20fffe4e950fa8a091611db5c5af3a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2e3fbfc490a21d2d085b5a65b08815b4b8c181bcf55f60d9862963d6e173a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
