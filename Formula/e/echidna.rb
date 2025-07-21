class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "d1977efb56969daf3df4011e6acd694ad88fc639575f7fe2998c2c291e5c8236"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c202ef8b9b824b25dbfcb077661791e479070d972250e7c6ac0b5baf61395f0e"
    sha256 cellar: :any,                 arm64_sonoma:  "dd58a75a9135efc12fe129daeffaf1f639a64d34ef238a47d7c2e4e2bed991e7"
    sha256 cellar: :any,                 arm64_ventura: "ba49676f81a95d8f3a97f43421f22fc3973a402eee419a7a795e0475960d9b56"
    sha256 cellar: :any,                 sonoma:        "923057174e82462ccff4e3a2340bf275dce0f56e93fdd8978e1b08ba1b725e0d"
    sha256 cellar: :any,                 ventura:       "6703a3bc7adc7596955f1ba07cc97f0daf85bf728feebd7aab482ce2ee0de4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5781ffa6f71ef4413b3cc28761ffc32536540aac247e0e70ba03668ba96a93b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f536d90b2756e575a6b6b74c22251b91ad5fe132ccf9286c46dae5a237310a24"
  end

  depends_on "ghc@9.8" => :build
  depends_on "haskell-stack" => :build

  depends_on "truffle" => :test

  depends_on "crytic-compile"
  depends_on "gmp"
  depends_on "libff"
  depends_on "secp256k1"
  depends_on "slither-analyzer"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{Formula["secp256k1"].include}",
      "--extra-lib-dirs=#{Formula["secp256k1"].lib}",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "truffle", "init"

    # echidna does not appear to work with 'shanghai' EVM targets yet, which became the
    # default in solc 0.8.20 / truffle 5.9.1
    # Use an explicit 'paris' EVM target meanwhile, which was the previous default
    inreplace "truffle-config.js", %r{//\s*evmVersion:.*$}, "evmVersion: 'paris'"

    (testpath/"contracts/test.sol").write <<~SOLIDITY
      pragma solidity ^0.8.0;
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    SOLIDITY

    assert_match("echidna_true: passing",
                 shell_output("#{bin}/echidna --format text --contract True #{testpath}"))
  end
end
