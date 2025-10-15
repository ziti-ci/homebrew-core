class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.8.tar.gz"
  sha256 "6574a4e8dab6dc5987c55f49ec0ffd66b3e86a3bd57106bdc60934d10946d8ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ff0450bb93d2ab1c17b8e919d55de3db15b5ca0b06d5640d430802bff141a31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885d6650032ce4dab6ce5921d144099a4a76eba217876c7586bdf2d47825c3ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db99bcc44c09976055abcddfeaea86e92119538938e02b3ccf3a7961578c791"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbe5d3cf6608866f753c018419f9eb50ee571e5fd5b30702461ef845ad0c977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "514f5310d5551d6c8c35d713a66f8d00ba03b2a89c8b48b77a940642c0446582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883d827159693e19d2040fcce4ebb324a4897e90ae0095a2465a4f839c52aa78"
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
