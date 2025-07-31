class Kissat < Formula
  desc "Bare metal SAT solver"
  homepage "https://github.com/arminbiere/kissat"
  url "https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.3.tar.gz"
  sha256 "53ad0c86a3854cdbf16e871599de4eaaaf33a039c1fd3460e43c89ae2a8a0971"
  license "MIT"

  def install
    system "./configure"
    system "make"

    # This should be changed to `make install` if upstream adds an install target.
    # See: https://github.com/arminbiere/kissat/issues/62
    bin.install "build/kissat"

    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/cnf/xor0.cnf", testpath
    output = shell_output("#{bin}/kissat xor0.cnf", 10)
    assert_match "SATISFIABLE", output
  end
end
