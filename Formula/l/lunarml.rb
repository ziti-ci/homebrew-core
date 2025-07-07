class Lunarml < Formula
  desc "Standard ML compiler that produces Lua/JavaScript"
  homepage "https://github.com/minoki/LunarML"
  url "https://github.com/minoki/LunarML/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f4efce99a17f2f7a479d0ab9d858d1c79624ddaba85f8bc08c06e186fd57ed9e"
  license "MIT"
  head "https://github.com/minoki/LunarML.git", branch: "master"

  depends_on "mlton" => :build
  depends_on "lua" => :test
  depends_on "node" => :test
  depends_on "gmp"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lunarml --version 2>&1")

    (testpath/"factorial.sml").write <<~SML
      val rec factorial = fn n => if n = 0 orelse n = 1 then
              1
          else
              n * factorial (n - 1);

      print (Int.toString (factorial 10) ^ "\n");
    SML
    system bin/"lunarml", "compile", "--lua", "factorial.sml"
    system bin/"lunarml", "compile", "--nodejs", "factorial.sml"

    assert_equal "3628800", shell_output("#{Formula["lua"].opt_bin}/lua factorial.lua").chomp
    assert_equal "3628800", shell_output("#{Formula["node"].opt_bin}/node factorial.mjs").chomp
  end
end
