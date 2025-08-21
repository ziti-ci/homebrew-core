class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "09e45a6f5dfc86819c31b8c157068b0e76bd52036c881210d6645973bbbdf55b"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8fd3c8c058ecf850d46435f718c38d480fb7d77210ab631882d8dc4af089485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fd3c8c058ecf850d46435f718c38d480fb7d77210ab631882d8dc4af089485"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8fd3c8c058ecf850d46435f718c38d480fb7d77210ab631882d8dc4af089485"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89f72d56bdb43488d74b6a9f47b3182a1d9601cb09a5800a7b3ec1afb741cfa"
    sha256 cellar: :any_skip_relocation, ventura:       "a89f72d56bdb43488d74b6a9f47b3182a1d9601cb09a5800a7b3ec1afb741cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4402f49cd1a7f4a18fa3e3926a13a769d1f12a6cefb1a988d47d19ee8fe9e2a"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~CLOJURE
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    CLOJURE

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end
