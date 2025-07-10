class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "017178f88bd923862b64f316098772c1912f2eef9304c1164ba257829f1bbfc2"
  license "MIT"

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre"

  def install
    system "nimble", "build", '--passL:"-lpcre -lssl -lcrypto"'
    bin.install "min"
  end

  test do
    testfile = testpath/"test.min"
    testfile.write <<~EOS
      sys.pwd sys.ls (fs.type "file" ==) filter '> sort
      puts!
    EOS
    assert_match testfile.to_s, shell_output("#{bin}/min test.min")
  end
end
