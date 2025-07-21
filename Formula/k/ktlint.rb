class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.7.1/ktlint-1.7.1.zip"
  sha256 "d453b8347587241559d583102c18993a6efc7d7d1064d1a380f8a58eb53a0675"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26caa0f95757c4b4e2425cfe4d4655e520b55bad6bec7076bcbb5877203b5a61"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~KOTLIN
      fun main( )
    KOTLIN

    (testpath/"Out.kt").write <<~KOTLIN
      fun main()
    KOTLIN

    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
