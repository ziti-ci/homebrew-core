class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.2.4.tgz"
  sha256 "79206742a7bf66bd38c0fe1ee6d6f8a089e783464c3909062e8b370f89e0845c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "a9e002dd4bf16aad4d08e272917cc70c443f893185641b8efd11cf5e11162761"
    sha256                               arm64_sonoma:  "a9e002dd4bf16aad4d08e272917cc70c443f893185641b8efd11cf5e11162761"
    sha256                               arm64_ventura: "a9e002dd4bf16aad4d08e272917cc70c443f893185641b8efd11cf5e11162761"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a95e26843d0ff7715ba0fd92054992c1965b94e5969fd76984598b67bdedcf"
    sha256 cellar: :any_skip_relocation, ventura:       "a3a95e26843d0ff7715ba0fd92054992c1965b94e5969fd76984598b67bdedcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7caab59ecdbbf79a4344eb38bf101ed50d479e092aac71fd74865f861408c55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc6e6777c7a857f11bc9b28bdcef58c39fe1de402aed477130690868fc266cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    (testpath/"test").mkpath
    cd testpath/"test" do
      system "git", "init"

      # Test backlog init command requires interactive input
      require "open3"
      Open3.popen3("#{bin}/backlog", "init", "test") do |stdin, _stdout, _stderr, wait_thr|
        stdin.puts "\n" # Send enter to proceed
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end
