class Cogapp < Formula
  include Language::Python::Virtualenv

  desc "Small bits of Python computation for static files"
  homepage "https://cog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/27/04/395d2067e7cb2e0c847dad74ef6048ce9cdf2c77c7add3805485455ac288/cogapp-3.5.1.tar.gz"
  sha256 "a9e8b8c31e5e47de722f27eaba1ec128dd6c8e7b6015555d9c8edaa5ad6092b4"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cog -v")

    (testpath/"test.cpp").write <<~CPP
      /*[[[cog
      import cog
      fnames = ['DoSomething', 'DoAnotherThing', 'DoLastThing']
      for fn in fnames:
          cog.outl("void %s();" % fn)
      ]]]*/
      //[[[end]]]
    CPP

    output = shell_output("#{bin}/cog test.cpp")
    assert_match "void DoSomething();\nvoid DoAnotherThing();\nvoid DoLastThing();", output
  end
end
