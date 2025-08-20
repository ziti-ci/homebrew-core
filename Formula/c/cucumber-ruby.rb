class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "7c6adb2d3124842c5dd78e27f0e620a5d780bee152144c8eccdc2b57924941ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d8ce1c5b083bcd28747f8ac25f517b8ec2a72e071ea01abc08b72f7e55654f7"
    sha256 cellar: :any,                 arm64_sonoma:  "42ef58af359627bf4f171fcec6489b2ed962ec08289bb10c7b50650d1813185f"
    sha256 cellar: :any,                 arm64_ventura: "fb7c7f395df3b38b4041117ea843fd32832bb69a8ec2aa90c43c00dd4cf2782e"
    sha256 cellar: :any,                 sonoma:        "2abcb235b49088f1ef4ec5ece107e92b1f216d7418fc61ba952397eb2346fa18"
    sha256 cellar: :any,                 ventura:       "888f0425eb8a60081fb48a87b0661a7adfcfc9538cf3e16e4222477c89dbbe7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f45502bc0e4a52558fa889b975398b81f3d077af122f9f3a30061ecff944506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fbfb7007f98c4a3a80f4bad850262a02cb3f42668dea0b16a5fe7fc03e6367"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/10.0.0/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.17.2.gem"
    sha256 "297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.3.1.gem"
    sha256 "b7b3eb817a9dd4a2f26a8b616a4f150ab1b79f4682d7538ceb992c8b7346f49c"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.6.2.gem"
    sha256 "9ae0d2cba7d4df3075fe8cd8602a8604993efc0dfa934cff568969efb1909962"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-27.2.0.gem"
    sha256 "46e2a1454620db3d0811ad990b9a96cd47bfdb5e2ad4f2ae0b41822332979fff"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-21.14.0.gem"
    sha256 "7fbaeb38c76e982848cf144136544853102ed906b6e54070bba409e505742267"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-18.0.1.gem"
    sha256 "8398a0bf636af33ff3b61e459a309295eb02745b9e21bd7af0eaaa2a1e6be3e5"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-6.1.2.gem"
    sha256 "f790e4e820b80d453e83c6a462ed6de36b9477b046543322f646c1e8c275916d"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-32.2.0.gem"
    sha256 "a33699d3be9c7fe1b6d4a26c1aa18150f274a90c871a6bc1811d5795a52e4ad6"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-15.2.0.gem"
    sha256 "18e45bd05d0fa44342b9f39d89b07a832063922d946c854e87013f94461b72a8"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-10.0.1.gem"
    sha256 "bb6e3fcec85c981dff4561997e8675a7123eead5fe9e587d2ad7568adbe18631"
  end

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.3.0.gem"
    sha256 "497918d2f9dca528fdca4b88d84e4ef4387256d984b8154e9d5d3fe5a9c8835f"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_path_exists testpath/"features"
  end
end
