class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-5.9.2.tgz"
  sha256 "67a3bc82e822b8f45f653a80fc3a9730d23214d36c83ba85dd7f5abebee82062"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af7b5de78b6badec07a3319bbfe295792ace24e06a50b7c8b66d6701d0af3521"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_path_exists testpath/"test.js", "test.js was not generated"
  end
end
