class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "984409a69f7385a9ec3738a460f3a23ff045503958b0c6ff36757d1bea599b07"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f3a9370b7c383b267686179e5634b2f17edf212034d977c34fda88d87a4524d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60f9d9388c43009aa599dc54cb5d1866c6300065a982d0dfbfede8abc91a28b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bcbc49ca0d9ec49000fbbbf904350cd2ac3955be2ff3658a0e26abf10fba3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3f1492e63637f9929235a9dc4229422fcc0fad10634eb5b7b07fd7b68c5e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d73a5e69e894d5ec8fdc49ece32d791a0c528ebb13daec59a085ea12feba4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d8fe12b8dde9411e5a5a53e16464e5a0a3d5362e72eb3130ac868f453ffe39"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end
