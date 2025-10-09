class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.40.0.tar.gz"
  sha256 "14e333c7454781f0b44fe9cba1616e25accfb04cf0d9d31db7acdd33e2e8d0ac"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb400990c3219c2811d71c7f994146195662ef642d98aa21b343665663c2a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9fac4a09ae0e9abd0c773de9d3e4c303b361d126566b0ae7956052035b5be19"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202510050144/geoip.dat"
    sha256 "c23ac8343e9796f8cc8b670c3aeb6df6d03d4e8914437a409961477f6b226098"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202510050144/geoip-only-cn-private.dat"
    sha256 "62a303deff40ce0d3735c2dc974b832f85b5f21892b03b0b4ae2acb53717d730"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250916122507/dlc.dat"
    sha256 "1a7dad0ceaaf1f6d12fef585576789699bd1c6ea014c887c04b94cb9609350e9"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
