class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2025_09_19.623dbf6.tar.xz"
  version "2025_09_19.623dbf6"
  sha256 "c5a916bdf084458ad791175aa2fe6f1984362524ada0cee84955ae144b6261cd"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "67546cccaba8cdba8cedbcf9d4146922a448a6527617fde9b686e4927210e2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36ca73de1ef71350be0509a42e2b5b7982c002d2aff3ad45108c4a983be5ce13"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    require "pty"
    PTY.spawn("#{bin}/passt --version") do |r, _w, _pid|
      sleep 1
      assert_match "passt #{version}", r.read_nonblock(1024)
    end

    pidfile = testpath/"pasta.pid"
    begin
      # Just check failure as unable to use pasta or passt on unprivileged Docker
      output = shell_output("#{bin}/pasta --pid #{pidfile} 2>&1", 1)
      assert_match "Couldn't create user namespace: Operation not permitted", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
