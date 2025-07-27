class Endlessh < Formula
  desc "SSH tarpit that slowly sends an endless banner"
  homepage "https://github.com/skeeto/endlessh"
  url "https://github.com/skeeto/endlessh/releases/download/1.0/endlessh-1.0.tar.xz"
  sha256 "b3e03d7342f2b8f33644f66388f484cdfead45cabed7a9a93f8be50f8bc91a42"
  license "Unlicense"
  head "https://github.com/skeeto/endlessh.git", branch: "master"

  uses_from_macos "netcat" => :test

  def install
    inreplace "endlessh.c", "/etc/endlessh/", "#{pkgetc}/"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    port = free_port
    pid = spawn(bin/"endlessh", "-p", port.to_s)

    sleep 5

    system "nc", "-z", "localhost", port
  ensure
    Process.kill "HUP", pid
  end
end
