class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  stable do
    url "https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
    sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"

    # Build fricas as a SBCL core file instead of standalone executable.
    # Avoid patchelf issue on Linux and codesign issue on macOS.
    patch do
      url "https://github.com/fricas/fricas/commit/4d7624b86b1f4bfff799724f878cf3933459507d.patch?full_index=1"
      sha256 "dbfbd13da8ca3eabe73c58b716dde91e8a81975ce9cafc626bd96ae6ab893409"
    end
    patch do
      url "https://github.com/fricas/fricas/commit/03e4e83288ea46bb97f23c05816a9521f14734b7.patch?full_index=1"
      sha256 "3b9dca32f6e7502fea08fb1a139d2929c89fe7f908ef73879456cbdd1f4f0421"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7c87044d00ac54aed75e3c74024198bfa1334da3cc66e378bb084e9bf34e8b2e"
    sha256 cellar: :any,                 arm64_sequoia: "6a4986f527a329cda2916c92b2065ae6d41aab08377bf751195b26a88036fd50"
    sha256 cellar: :any,                 arm64_sonoma:  "c254d2cb770eb7c6796fa9293b06d01c6ffb14be778254ab3a26fc17a8eb8bec"
    sha256 cellar: :any,                 sonoma:        "9b27da492022588d3d26575fa5f103bfe38f6102679fce800ac4ef9ce8e76343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc084992d8a884fc40ab26b670100ea7aa8e83e91baabb22a9eac3e3687ae9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8412b5815cf0fa53cadd4b4608ba229c84aa50120023fe04279f4e19a9a83360"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
