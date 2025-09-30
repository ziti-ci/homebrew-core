class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "d56ce1157dfa9169bf24a065267761969c6720f9ff8d7a7b15f4dd32bbdad75f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "002c3b2463bf3ce4c89d24585befb79b6c22691a393dd6f5c8e9dcf1ba94e428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64008c2265844c7fc8f6bee418d7c09f566f2579ed87c4a9dd55e69bc515c395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca383219cff448e91f714e99de1b3d5a0adeea55e026e219f4e6d595ac173ac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7460089b27a9bb8b1e445041f7e6d7c3837e71284be4f393a146c479e53e9cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a2f311c9d6530a5899d0bb0b398cea7de3360578f8bc2bfe5ea4480e154d5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba88b577f8d0324361adea391016a3cb4d4a1893568102b3f9922f90ac666985"
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
