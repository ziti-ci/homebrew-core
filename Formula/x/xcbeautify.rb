class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.30.0.tar.gz"
  sha256 "d63978cce40a1552b91b31003f53597af970da99acd3e5559acbdf50e204e9eb"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c6abc592dec84cbec4c28959522a17be58051c2ef041f60988c8e805b0a591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7bdab4d933fcf8623bd844b1effb33c0dd246b8295d8e929c0a02875a963501"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce30c0a926668006ae3730a661df2c4bf139a0666e5ae0ac80ef9366ee5e8170"
    sha256 cellar: :any_skip_relocation, sonoma:        "315b82d94604de8ecaa655e18c8196f612c8dba71334cf3db4f4bca1effaab17"
    sha256 cellar: :any_skip_relocation, ventura:       "99fdc6e6b5962e736ec1bf061207c8db86a629e80b19757dd9d1f11229edfd90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72993127a46f6029e4c2588d57a12f189f3169b75f5a84d1561c0261043c20f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec8eff8d05d3f91857c56030e2830b18e685eb3634039f36abe8251cad3a331"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
