class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.12/psysh-v0.12.12.tar.gz"
  sha256 "a8342dbf7508eec69b3dca78a8a2703fc22c3818e11581dba177a445d414802e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "570405c19eb330a12167a5b2a9c79a4f026d0247ed2ee3e6ab176fcfdf842afd"
    sha256 cellar: :any_skip_relocation, ventura:       "570405c19eb330a12167a5b2a9c79a4f026d0247ed2ee3e6ab176fcfdf842afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
