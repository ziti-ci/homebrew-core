class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.10.4/flyway-commandline-11.10.4.tar.gz"
  sha256 "01b9ff3bc5957feae3370247332c6b832f4183bcfeeefc622a32c3f4dfb94b8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4380e623b176a6ed26d31e177b50bfc0a3b5b546a28dce209c63ed1257f9014"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
