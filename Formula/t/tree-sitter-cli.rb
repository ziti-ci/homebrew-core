class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "178b575244d967f4920a4642408dc4edf6de96948d37d7f06e5b78acee9c0b4e"
  license "MIT"

  livecheck do
    formula "tree-sitter"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"tree-sitter", "complete", shell_parameter_format: :arg)
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~JS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    JS
    system bin/"tree-sitter", "generate", "--abi=latest"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system bin/"tree-sitter", "test"
  end
end
