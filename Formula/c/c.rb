class C < Formula
  desc 'Compile and execute C "scripts" in one go'
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ecfad78cb0ab56da44dcfed805f5c261ddefd6dc4a4e57eb2dcfcffa85330605"
  license "MIT"
  head "https://github.com/ryanmjacobs/c.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "eebb1128fae6df85637e7549c813991361c29fe62b02d4b003ebf2b5d37404ca"
  end

  def install
    bin.install "c"
  end

  test do
    (testpath/"test.c").write("int main(void){return 0;}")
    system bin/"c", testpath/"test.c"
  end
end
