class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "ae8f8caa79950385ada597bb6d9ba08a3668e04f771bd997b5e6c41c6aec22ea"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95cba04dee9d47fb83e3d24a255652e42693ff14eba0ba5ba77f4f123332997c"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
