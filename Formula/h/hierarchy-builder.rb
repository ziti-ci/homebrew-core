class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.0/hierarchy-builder-1.10.0.tar.gz"
  sha256 "a1de2ae6b5583f26c57db62e337f02c60d0b51c621b686d91dec3650479c0970"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    system "make", "build"
    system "make", "install", "COQLIB=#{lib}/ocaml/coq"
  end

  test do
    (testpath/"test.v").write <<~ROCQ
      From HB Require Import structures.
      From Stdlib Require Import ssreflect ZArith.

      HB.mixin Record IsAddComoid A := {
        zero : A;
        add : A -> A -> A;
        addrA : forall x y z, add x (add y z) = add (add x y) z;
        addrC : forall x y, add x y = add y x;
        add0r : forall x, add zero x = x;
      }.

      HB.structure Definition AddComoid := { A of IsAddComoid A }.

      Notation "0" := zero.
      Infix "+" := add.

      Check forall (M : AddComoid.type) (x : M), x + x = 0.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_equal <<~EOS, shell_output("#{Formula["rocq"].bin}/rocq compile test.v")
      forall (M : AddComoid.type) (x : M), x + x = 0
           : Prop
    EOS
  end
end
