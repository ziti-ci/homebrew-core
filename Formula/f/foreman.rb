class Foreman < Formula
  desc "Manage Procfile-based applications"
  homepage "https://ddollar.github.io/foreman/"
  url "https://github.com/ddollar/foreman/archive/refs/tags/v0.89.1.tar.gz"
  sha256 "49d058ce2ac5dc8a05478dcfefd98d25a6740d29314924cc481f185663f51974"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ed065a7aff5e0a13b9645db33d36916f925d9b5943abd9c84b4d7f434bc329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ed065a7aff5e0a13b9645db33d36916f925d9b5943abd9c84b4d7f434bc329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77ed065a7aff5e0a13b9645db33d36916f925d9b5943abd9c84b4d7f434bc329"
    sha256 cellar: :any_skip_relocation, sonoma:        "77ed065a7aff5e0a13b9645db33d36916f925d9b5943abd9c84b4d7f434bc329"
    sha256 cellar: :any_skip_relocation, ventura:       "77ed065a7aff5e0a13b9645db33d36916f925d9b5943abd9c84b4d7f434bc329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933a0892b69de4221ed745cd8ef0258d78b49c3e4bc63e4d920789600d4071bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933a0892b69de4221ed745cd8ef0258d78b49c3e4bc63e4d920789600d4071bf"
  end

  uses_from_macos "ruby"

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/foreman.1"
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/foreman start")
  end
end
