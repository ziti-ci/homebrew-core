class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.1.0/qbs-src-3.1.0.tar.gz"
  sha256 "0fe497e72174bcd94aba4173c36f034ae7d1b3c4f38ed39e1fe4bee2e6929f75"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "744c54ac7722c99cd35fff1243b7149bc342e722b9f730656a3f948a313018b6"
    sha256 cellar: :any,                 arm64_sequoia: "897b6fbf6667d4ba08ccc8baed8435d2dd2710d26a7400311e407a1fed49f9ce"
    sha256 cellar: :any,                 arm64_sonoma:  "f362ce03374da267567565ddcbc3a04a698651c1b5a0d55d18148e28c8124c60"
    sha256 cellar: :any,                 sonoma:        "0c3d67b19b77163bebd1245fbf4111ab96ceef403a5938550790dca2e07f560b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa26c6fe79c5614f055df559f2c3aaa3f320698e52552257aa6654cfe06761d"
  end

  depends_on "cmake" => :build
  depends_on "qt5compat"
  depends_on "qtbase"

  def install
    args = %w[
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~QBS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    QBS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end
