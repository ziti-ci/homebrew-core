class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "0c602853d2170c7104c767849935851baaf5a2c551ef0add040319ac3afe9bfc"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41cda102e79d645a3bb38ed5f67203278116928d6a3ecdc4b40909967c73d341"
    sha256 cellar: :any,                 arm64_sonoma:  "536098b9765d42f842c170bc4c730386ef095b9eee13306611b69d7eda587df2"
    sha256 cellar: :any,                 arm64_ventura: "4fec9781020e0eb043aafc2d980050327297b7b8463a55ef1f73729ab2978702"
    sha256 cellar: :any,                 sonoma:        "ed3d031820c4b4cc2f90673ea5a176914e5fe3dc1ce05a901f8cfc2b1fcf9d4b"
    sha256 cellar: :any,                 ventura:       "0175639a88d192c77167387359890c0fc14bf73516895fed7d3de9136a8a38cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddedbc5d6a86b753345aa92410d4e41bf310856ea95b910d485fa674beebf4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499163a3c6ff4ba45953f660ac8611de0557d410ae85251839e3d7a2e35fb170"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    # Workaround for newer Protobuf to link to Abseil libraries
    # Ref: https://github.com/grpc/grpc-java/issues/11475
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", Utils.safe_popen_read("pkgconf", "--cflags", "protobuf").chomp
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp

    inreplace "compiler/build.gradle" do |s|
      # Avoid build errors on ARM macOS from old minimum macOS deployment
      s.gsub! '"-mmacosx-version-min=10.7",', ""
      # Avoid static linkage on Linux
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{Formula["protobuf"].opt_lib}\""
      s.gsub! ', "-static-libgcc"', ""
    end

    args = %w[--no-daemon --project-dir=compiler -PskipAndroid=true]
    # Show extra logs for failures other than slow Intel macOS
    args += %w[--stacktrace --debug] if !OS.mac? || !Hardware::CPU.intel?

    system "gradle", *args, "java_pluginExecutable"
    bin.install "compiler/build/exe/java_plugin/protoc-gen-grpc-java"

    pkgshare.install "examples/src/main/proto/helloworld.proto"
  end

  test do
    system Formula["protobuf"].bin/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end
