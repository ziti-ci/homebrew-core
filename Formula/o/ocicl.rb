class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "3477659863514ac1188b7177ad9b75a93b580a42c67573cadb4bcb67142d4908"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8f729be96e591cc707f460509a12d820737a3da5933ab546d53817cacb4263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72dc8af4c6c882154b45d05818d6efd7ac5ff4268d2bcad6394a48f3281338bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551d783f8a184d016751480022ad3383eb6af2d097292c6f21c712e175091a51"
    sha256 cellar: :any_skip_relocation, sonoma:        "a90813b132f0ccbdde30baea94947e0cb5e52e2f934d162e66f6dc0a814ce49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffd4b7f228e4e97832f645493fb217f27cab9a007c7574337659dd092a367fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9edaface6dfda2ccbe9b043f5f84a40f13494a620ff72b1621ca51dddedcd13"
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
