class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.4.0.tgz"
  sha256 "8be7492a73464752fc078f46d383e61b7827f203dc18a9995250f6093cdb9e67"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "5ddf23561459beff02bb7d6262ec2cd247a9f9383622c9e668735b1281bfd252"
    sha256                               arm64_sonoma:  "5ddf23561459beff02bb7d6262ec2cd247a9f9383622c9e668735b1281bfd252"
    sha256                               arm64_ventura: "5ddf23561459beff02bb7d6262ec2cd247a9f9383622c9e668735b1281bfd252"
    sha256 cellar: :any_skip_relocation, sonoma:        "daad3206f1033e005534882f6d8baf4fa77ad7a8cb5ac2ae264dc4c473d60094"
    sha256 cellar: :any_skip_relocation, ventura:       "daad3206f1033e005534882f6d8baf4fa77ad7a8cb5ac2ae264dc4c473d60094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ad93de568d0680f6ab33ba3b81ed919957deef2f2d81a2d923f54ef618b7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ca700291d2bcbc6a99e14f7a307cd17892df4589b6b634c3bacb9d2b94afe1"
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
        stdin.puts "y"
        sleep 1
        stdin.puts "y"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end
