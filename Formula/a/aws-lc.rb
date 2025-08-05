class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "52b2284dedd8b0da8b75c51997954cb98cec157747496c41937a5c8c22919590"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8844c3f48f471c749a010c22d87623abfe5e60c2483bc2fc73015ea94e32ec73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "485c5f92bf8d58ea2b7b79499cde4b1e479ef302b6cf89639d67d71664e82559"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1ce4437bd6127e7d7941ebeeef8b6149b6840fdeb43257eb3296db3e3143f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a26d586cce1dd65559a98491fe7390fe7dd9164bc808afba421ecfe9892b80"
    sha256 cellar: :any_skip_relocation, ventura:       "17f1029713eae8668cccde1c41ada27f8afdd3ed78756cec59718b44eca2d32b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d088f4f4503b621184719091c39970222a61b16e8e7c4810e33a72240d1749a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7faa17424b9082b3bfbebf5f04e6c83083d559a9779a5e348fbd3ba09948893f"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %w[
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_BINDIR=bin
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    output = shell_output("#{bin}/bssl sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end
