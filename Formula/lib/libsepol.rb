class Libsepol < Formula
  desc "SELinux binary policy manipulation library"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.9/libsepol-3.9.tar.gz"
  sha256 "ba630b59e50c5fbf9e9dd45eb3734f373cf78d689d8c10c537114c9bd769fa2e"
  license "LGPL-2.1-or-later"

  depends_on "rpm2cpio" => :test

  uses_from_macos "flex" => :build
  uses_from_macos "cpio" => :test

  on_macos do
    depends_on "coreutils" => :build # for GNU ln
  end

  def install
    args = %W[
      PREFIX=#{prefix}
      SHLIBDIR=#{lib}
    ]

    # Submitted to upstream mailing list at https://lore.kernel.org/selinux/20250912132911.63623-1-calebcenter@live.com/T/#u
    if OS.mac?
      args += %w[
        TARGET=libsepol.dylib
        LIBSO=libsepol.$(LIBVERSION).dylib
      ]
    end

    system "make", "install", *args
  end

  test do
    resource "homebrew-example-policy" do
      url "https://web.archive.org/web/20250912032601/https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Server/x86_64/os/Packages/s/selinux-policy-targeted-42.8-1.fc44.noarch.rpm"
      sha256 "f551899bec63f9496e4fda49db734a0dbd740c63537d3d4bf285cc5c742b8c2a"
    end

    resource("homebrew-example-policy").stage testpath

    pipe_output("cpio -idm", shell_output("rpm2cpio selinux-policy-targeted-42.8-1.fc44.noarch.rpm"))
    policy = "etc/selinux/targeted/policy/policy.35"
    context = "system_u:object_r:httpd_sys_content_t:s0"
    output = shell_output("#{bin}/chkcon #{policy} #{context}")
    assert_equal "#{context} is valid\n", output
  end
end
