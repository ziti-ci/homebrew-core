class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "763d5a9a8d71606f319e2eb5a1f2a8f017ef58f4e47f8ed5f0185000d0ed62e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd0af88123d9b1727888830c3d81e70e2cfbaaa66b3c6e6bc882484d45a1b924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02ae8b66c20966e8dc81a6344168932f7423155c4065aaf8175a4e3c7c45400c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9352a4fe6819c84fcd16a6516824f30c1538a4b6c8fab24da00cea2d3bdc2bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c84dd0667191d94eedb83186131306da8431d92b288176e3c0054f838888d35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3644a72622d0216981a7005edd3d0b5b55a79b61fb0929322c5c6c19cc669256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd68b9f16d46997fdbe1a1a9b3d1c3a1ae7ec2dbf7043fe9b2761cc7a316c79"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
