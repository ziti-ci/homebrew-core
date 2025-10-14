class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 3
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b48a9141fb822f7cfe7be8f331e7fc807b7c82b466d40e0718c5e736e8bce43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edaf9f4d2feb2e6e4f18dc167944ff8823c9c4068c6e07017d8921ca160b28a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b76e1afa8be0eec8c8fd7197460b4477faaf325cd2fc18c0339ee725b06a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949b8dd9dc1b6fcaa86472561cec958b13a0c204be09e5634341601db3fe5f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1d9cff133d630041fe8d16efd19643523f4dfbb248840c9b4f932ca01902d07"
    sha256 cellar: :any_skip_relocation, ventura:       "95452863449dda54f90ae2dd8a3c01732634b8a974ced293149747b7551813d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8c3e1a56addbd31b292339933393e6e354b7e02f7cd9c3a4c05a3f58e7a014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7e179568b81994be74447f225712ad2efeef31045af99657a6671f6a98a963"
  end

  depends_on "neovim"
  depends_on "python@3.14"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/04/d7/c4412e6219661fd8689cdd9553988f8ea38c151067d70c49436977688aa9/pynvim-0.6.0.tar.gz"
    sha256 "0ffcb879322d08f9e9061e1123dd58ba3a5ccfbd4999bb1157bac525822aa590"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    socket = testpath/"nvimsocket"
    file = testpath/"test.txt"

    nvim = spawn(
      Formula["neovim"].opt_bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", "--listen", socket, file,
      [:out, :err] => "/dev/null"
    )
    sleep 1 until socket.exist? && socket.socket?

    str = "Hello from neovim-remote!"
    system bin/"nvr", "--servername", socket, "--remote-send", "i#{str}<ESC>:write<CR>"
    assert_equal str, file.read.chomp
    assert_equal Process.kill(0, nvim), 1

    system bin/"nvr", "--servername", socket, "--remote-send", ":quit<CR>"

    # Test will be terminated by the timeout
    # if `:quit` was not sent correctly
    Process.wait nvim
  end
end
