class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20250903/menhir-20250903.tar.bz2"
  sha256 "17240a67cc724911312a09a1af6b35974450279a71f18c71ef4eacae5f315358"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b2468fc64410b839861ee2531605435a84c67ec1732b3b10a6f6f58df942026"
    sha256 cellar: :any,                 arm64_sonoma:  "21faae7f40879726a7182fc3a2b06782d05f20ac7c6a78c24c89924e9b987d5f"
    sha256 cellar: :any,                 arm64_ventura: "e4ab6e13c7d88cd011a87a1ab70c1402b91d52c6e063ca9b053488a5cb4dd7fb"
    sha256 cellar: :any,                 sonoma:        "21785efb5af4a838f5677dc7c5b13d84baa8b59d8bb3fb6e3f89fc36a9e3f013"
    sha256 cellar: :any,                 ventura:       "2ed3b598496bb3807dd23ab878d762f9a10138d34ebbbf35e6a06e77a0c45afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8e624c73e5eb0cda890d15259ce19b2fb6d81a5f9f8bf1a375d82087fbf662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e470ee3bce1d4a0c52223cc49d7cbce48c7115fe819a54bcd09bf2e66b1187d8"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system bin/"menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_path_exists testpath/"test.ml"
    assert_path_exists testpath/"test.mli"
  end
end
