class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f8b9c864c0bdc8e56fbd709fb97a04b43b989815641b8bd9aae2e5fbc43b6930"
  license "MIT"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
