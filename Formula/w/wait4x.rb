class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "0c97d72d415b5969472225e0c75218cf505b49ad48a3204967a2483208b6d97e"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
