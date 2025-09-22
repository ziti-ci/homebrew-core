class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "bb42cb54b5bb50fab38fb28163e5b4397e22255a7a65e838e2961f79a17ab1e9"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    (lib/"typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed")[0].children, lib/"typeshed"
    bin.env_script_all_files(libexec/"bin", ZUBAN_TYPESHED: lib/"typeshed")
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match(/(not assignable|incompatible|error)/i, out)
  end
end
