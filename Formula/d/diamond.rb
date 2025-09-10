class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "161a5f008a0a2f38fbe014abc0943d2b9b482510a3a64e4e3ab7230ddddd484e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb004a5f8e1f3aa3a3caecb60872bc1dc93322c65ca2f185e62ae5f90e6fb82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5deb210bf9cb7790e85ba12423d470dfef522326f8048c57e30a9e077ccf827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5161c709bb96f99aecd0b33b584c5254b8d98ece89c40f6e17173f9ee4310ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0805fec734a034b56d786381f6e290536b547287284fe49d3c917db77c624df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "814fa54602ac1ead2779baec592af6a352bc63b47310ed4a882c595a0832147b"
    sha256 cellar: :any_skip_relocation, ventura:       "ddce693dee8ad251c30a4339cb78a1697c89adbcda25de9f0636137390a34d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855f41e69ca7de3e5ba0ed58f11109b579e5afde0263edc9d7611cb8fc508295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe0a2ed40864c1c5aab11e2d7eac871ace638d377ae3efc8cf93c9a3cd2cdfc"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  # Fix to build error on macos
  patch do
    url "https://github.com/bbuchfink/diamond/commit/68963336dab5dd02a4ce5bf7a3e936cd919244b0.patch?full_index=1"
    sha256 "5522d188beb8c6296f3cd39f5ab0a7ce8dffce265f0e8a761b873368c75befb8"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"nr.faa").write <<~EOS
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf1
      grarwltpvipalweaeaggsrgqeietilantvkprlyXkyknXpgvvagacspsysgg
      XgrrmaXtreaelavsrdratalqpgrqsetpsqkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf2
      agrggsrlXsqhfgrprradhevrrsrpswltrXnpvstkntkisrawwrapvvpatrea
      eagewrepgrrslqXaeiaplhsslgdrarlrlkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf3
      pgavahacnpstlggrggritrsgdrdhpgXhgetpsllkiqklagrgggrlXsqllgrl
      rqengvnpgggacseprsrhctpawaterdsvskk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-1
      fflrrslalsprlecsgaisahcklrlpgsrhspasasrvagttgarhharlifvflvet
      gfhrvsqdgldlltsXsarlglpkcwdyrrepprpa
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-2
      ffXdgvslcrpgwsavarsrltassasrvhaillpqppeXlglqapattpgXflyfXXrr
      gftvlarmvsisXprdppasasqsagitgvshrar
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-3
      ffetesrsvaqagvqwrdlgslqapppgftpfsclslpsswdyrrppprpanfcifsrdg
      vspcXpgwsrspdlvirpprppkvlglqaXatapg
    EOS

    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr 2>&1")
    assert_match "Database sequences  6\n  Database letters  572", output
  end
end
