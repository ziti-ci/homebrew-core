class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "29b1d98e96638d62d71aa990d8fbcd8bb3e03e5017d4015b8da11af194158179"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e8f6445c6cd0e6597cf42aaf4c59548847d76c49370161e65411be8a73a247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e8f6445c6cd0e6597cf42aaf4c59548847d76c49370161e65411be8a73a247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29e8f6445c6cd0e6597cf42aaf4c59548847d76c49370161e65411be8a73a247"
    sha256 cellar: :any_skip_relocation, sonoma:        "424786ebba1b7081ddd38f13726716b26982f6162001a0950f8218efb74b9fac"
    sha256 cellar: :any_skip_relocation, ventura:       "424786ebba1b7081ddd38f13726716b26982f6162001a0950f8218efb74b9fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c798b3ea806a2db9011edffefb7b254fc859a8b7cf23fa5bdf06a8baf22769"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
