class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.0.tgz"
  sha256 "d163a3c3efd067693cb1da5799b3be3ed4953207db21fedc5f8574ded875542a"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "06fc398bbda6aefc685064b89a2067193f4ca13457c2f8a76945e0bf7df590be"
    sha256                               arm64_sonoma:  "06fc398bbda6aefc685064b89a2067193f4ca13457c2f8a76945e0bf7df590be"
    sha256                               arm64_ventura: "06fc398bbda6aefc685064b89a2067193f4ca13457c2f8a76945e0bf7df590be"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d6e581ada95732693037308381cf8e6bdae0777bfad3a9c5be7618e3f768fc"
    sha256 cellar: :any_skip_relocation, ventura:       "61d6e581ada95732693037308381cf8e6bdae0777bfad3a9c5be7618e3f768fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c5b0d97ca871dd9c955bceaa861aa8ca47bb3011e86e82ba8da28cfccb52d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d9d8a16363805a4e23230744bc915e3be46064c52a36cb34c1741f2971107f"
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
