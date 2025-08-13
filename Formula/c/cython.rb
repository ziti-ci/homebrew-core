class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/18/ab/915337fb39ab4f4539a313df38fc69938df3bf14141b90d61dfd5c2919de/cython-3.1.3.tar.gz"
  sha256 "10ee785e42328924b78f75a74f66a813cb956b4a9bc91c44816d089d5934c089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6149b960fe4b737e331e86645b1c9d508ff7bdc8cf5b73e99d165096fc7f94b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08b16148b890d63f6204eb10c8d906f72751fb23b6bce79b5d63f84ac2bda8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb1ac6f6d311be63424bda991ddd9f9a7179635809151f6b349f8ddd72e856db"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d0ede4966c9f220f502c08a0441e8f344f34d6a00d105bb6943f5a966cbf85"
    sha256 cellar: :any_skip_relocation, ventura:       "d78513b902111d7826c52f6a04035b248d04656144e75ca59ee7b27ddc6d6311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0730c3aca106185dcf247e5af41ee3ca03f40d576790f8a1245547293768509e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862da5fc26bf6ffc960159a4cb25992b9751a1ad90212db666e9d56a449c967f"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
