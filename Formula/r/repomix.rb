class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.5.0.tgz"
  sha256 "48ca6b6c55c8d51aeaff748c6e646718f5fdec35418659974d9b0fed700fc868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232d4b3b45a605c23f927ed48587dcf59b37544fac3816c83ff0d83e800b5e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232d4b3b45a605c23f927ed48587dcf59b37544fac3816c83ff0d83e800b5e59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "232d4b3b45a605c23f927ed48587dcf59b37544fac3816c83ff0d83e800b5e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "232d4b3b45a605c23f927ed48587dcf59b37544fac3816c83ff0d83e800b5e59"
    sha256 cellar: :any_skip_relocation, ventura:       "232d4b3b45a605c23f927ed48587dcf59b37544fac3816c83ff0d83e800b5e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66e6d6600e66a04d5f7d69e637d7f9b189ad2fcbd7c5698d4ee44e64a6056d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66e6d6600e66a04d5f7d69e637d7f9b189ad2fcbd7c5698d4ee44e64a6056d2"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
