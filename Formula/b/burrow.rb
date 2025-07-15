class Burrow < Formula
  desc "Kafka Consumer Lag Checking"
  homepage "https://github.com/linkedin/Burrow"
  url "https://github.com/linkedin/Burrow/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "2881112e8fb4e5a662389a582c6044ed0e3359a03e26f446b8242929a7f82423"
  license "Apache-2.0"
  head "https://github.com/linkedin/Burrow.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    inreplace "docker-config/burrow.toml" do |s|
      s.gsub!(/(kafka|zookeeper):/, "localhost:")
      s.sub! "docker-client", "homebrew-client"
    end
    (etc/"burrow").install "docker-config/burrow.toml"
  end

  service do
    run [opt_bin/"burrow", "--config-dir", etc/"burrow"]
    keep_alive true
    error_log_path var/"log/burrow.log"
    log_path var/"log/burrow.log"
    working_dir var
  end

  test do
    port = free_port
    (testpath/"burrow.toml").write <<~TOML
      [httpserver.default]
      address="localhost:#{port}"
    TOML
    spawn bin/"burrow"
    sleep 1

    output = shell_output("curl -s localhost:#{port}/v3/kafka")
    assert_match "cluster list returned", output
  end
end
