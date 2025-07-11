class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/10.0.0/bazel-diff_deploy.jar"
  sha256 "dfa1957bd5d23ff5886d3d0f69394106d520b0a5c3d251b55fdd4d57b52992a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f250a031ed2c94fb90b7573f81f054c7202bcb36acca3b021f6cbda2cbf69b91"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
