class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "39713a5bfd6fd1a2df1caa7a8296c4327e48c51e964c83d5fea4ed3a5ba4df9f"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e807aa834bc6ef8dc284b501ee185dd88902bec87c89cb36eb090b39ba630f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52e72fd3ef6e9e101ec60a33de222be7373b6730d0047585715e9bc585916f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0d90a2719d2847653f4865b864aaf42168dbdbc305021f89ff8721180db84ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "b615066ba2eb186b114804e6a8310455860a59416d297c209d470b217632b9d4"
    sha256 cellar: :any_skip_relocation, ventura:       "ef3c578bcb1e2e26f4ae080b55f1270e310351605815c192bdc0a3389ceb4b65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315580f4235c1735ab27d1d6b1dd577add6c459c0ba8b2322ae529a3e485eabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823193a6aacf52e2d272adfab6521b2b50d1b04cea597ad327f90da8205adb95"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
