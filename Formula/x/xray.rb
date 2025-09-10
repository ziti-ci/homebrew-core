class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.9.10.tar.gz"
  sha256 "c26b1e3533540f63acb641cea9af660fae60bd50b6ee4a9904858a073161f3dd"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4004bb34022e2c9ccebe83fc4af3de4ebc145c14f2e4ba11ef0fa02a8394ac6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4004bb34022e2c9ccebe83fc4af3de4ebc145c14f2e4ba11ef0fa02a8394ac6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4004bb34022e2c9ccebe83fc4af3de4ebc145c14f2e4ba11ef0fa02a8394ac6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "225998d0e42a5e1ca7bf8ef4118c899561240eb35ba6c64e479b27dd050be583"
    sha256 cellar: :any_skip_relocation, ventura:       "225998d0e42a5e1ca7bf8ef4118c899561240eb35ba6c64e479b27dd050be583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b907a72a19a8427ceb72a0344ce22eee722bfcd018d1175097f2f41f91c6300"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip.dat"
    sha256 "a01e09150b456cb2f3819d29d6e6c34572420aaee3ff9ef23977c4e9596c20ec"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250829121920/dlc.dat"
    sha256 "186158b6c2f67ac59e184ed997ebebcef31938be9874eb8a7d5e3854187f4e8d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.38.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
