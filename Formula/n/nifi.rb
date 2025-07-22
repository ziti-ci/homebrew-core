class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.5.0/nifi-2.5.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.5.0/nifi-2.5.0-bin.zip"
  sha256 "b7235c21ec4d3a97d64e3101049f3bc86ef656041c02f1596d82227b9ee9a159"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28c357c40be403487a5eac16e68d4810906a75c76290628b6a9f57ad86b4c943"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)

    # ensure uniform bottles
    inreplace libexec/"python/framework/py4j/java_gateway.py", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"nifi", "status"
  end
end
