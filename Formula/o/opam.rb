class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.4.1/opam-full-2.4.1.tar.gz"
  sha256 "c4d053029793c714e4e7340b1157428c0f90783585fb17f35158247a640467d9"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/ocaml/opam.git", branch: "master"

  # Upstream sometimes publishes tarballs with a version suffix (e.g. 2.2.0-2)
  # to an existing tag (e.g. 2.2.0), so we match versions from release assets.
  livecheck do
    url :stable
    regex(/^opam-full[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552d02f787a46798a9712b6430860fe480d0f7c7947b357f5486423064595eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0ebf283566f00fe8f335c55e41dbfd67a5912655941d20f5dc52c41e7806a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "198ffdebac78a5600c5d879ccd5b0ef5516df0bace84b26a0781d162c94166d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ede48f138f45f4a182a8606c5827c4131dd1178c98f0b01c6abc011fe27f2c"
    sha256 cellar: :any_skip_relocation, ventura:       "c9c76c437778ebd609200576435075541d70b3b70166a8b5ea31d03132d12aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d3d912d9b2c27242747ed3098a4024fbcb322522c70e784c62b3949a9492f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725b1904073b595a10e93ca355d6bdb8b3232f97709ef8b6d4a9ae47e84e3f1f"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "rsync" # macOS's openrsync won't work (see https://github.com/ocaml/opam/issues/6628)

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-vendored-deps", "--with-mccs"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~/.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin/"opam", "init", "--auto-setup", "--compiler=ocaml-system", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
