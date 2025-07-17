class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.102.1.tgz"
  sha256 "5cbeca56410e350c4cd00c1f0e07743fe3f89f3efc66cd7d6de6ebc040bf4978"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae65825b3e1839ee33e6fe6dc699edc22bc2324667f50d3e0c45863c3e9e2f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2c6f540a1d162249450abe7126aba31149a0b4243de4fe443bde6486d5d5b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7863eebd90a428fc41312dd4129329ac3b51e9bde0de35bbcb331f4fb757f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b7199455dd1c7ffe93ec8ed90e02cb018b9a14361f55d008905fee211bfa3a"
    sha256 cellar: :any_skip_relocation, ventura:       "494d51bc8df5ad74b05793552e65a5b5a555c6e1ab9788481d2b0d659b05f5f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a644f0ba10fd0132785f35abbea9c10f7bd9c795a7af6b4a6bbf455405d5cc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c9f7c12e7b0e8c77e8f5ae065395c28b86cb5e954956ce0274b5aed7f8ca46"
  end

  depends_on "pkgconf" => :build
  depends_on "node@22"
  uses_from_macos "python" => :build

  on_linux do
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec/"lib/vscode/node_modules/@parcel"
    permitted_dir = OS.linux? ? "watcher-#{os}-#{arch}-glibc" : "watcher-#{os}-#{arch}"
    vscode.glob("watcher-*").each do |dir|
      next unless (Pathname.new(dir)/"watcher.node").exist?

      rm_r(dir) if permitted_dir != dir.basename.to_s
    end
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}/code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end
