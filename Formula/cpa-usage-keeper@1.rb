class CpaUsageKeeperAT1 < Formula
  desc "CPA usage persistence and dashboard service (v1)"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  license "MIT"
  version "1.15.11"

  keg_only :versioned_formula

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v1.15.11/cpa-usage-keeper_v1.15.11_darwin_arm64.tar.gz"
      sha256 "340268197fb20e57832c5df1487977d853d49cc8e6e135f65d07a45ff2c947a2"
    end

    on_intel do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v1.15.11/cpa-usage-keeper_v1.15.11_darwin_amd64.tar.gz"
      sha256 "031826dad18e2c63ba818c8ff399b8ff87f0865e8f8658af99e38b98af5ef47d"
    end
  end

  def install
    inreplace ".env.example", "WORK_DIR=./data", "WORK_DIR=#{var}/cpa-usage-keeper@1"

    bin.install "cpa-usage-keeper"
    etc.install ".env.example" => "cpa-usage-keeper@1.env.example"
    pkgshare.install "README.md", "README.zh.md", "LICENSE"
  end

  def post_install
    (var/"cpa-usage-keeper@1").mkpath

    env_file = etc/"cpa-usage-keeper@1.env"
    cp etc/"cpa-usage-keeper@1.env.example", env_file unless env_file.exist?
  end

  service do
    run [opt_bin/"cpa-usage-keeper", "--env", etc/"cpa-usage-keeper@1.env"]
    working_dir var/"cpa-usage-keeper@1"
    keep_alive true
    log_path var/"log/cpa-usage-keeper@1.log"
    error_log_path var/"log/cpa-usage-keeper@1.err.log"
  end

  def caveats
    <<~EOS
      Edit the v1 configuration before starting the service:

        #{etc}/cpa-usage-keeper@1.env

      Required values include CPA_BASE_URL and CPA_MANAGEMENT_KEY. LOGIN_PASSWORD is also required unless authentication is explicitly disabled.

      This formula uses separate configuration and data from cpa-usage-keeper.
      To keep existing v1 data, follow the switching instructions in the tap README.

      Start the service with:

        brew services start cpa-usage-keeper@1
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cpa-usage-keeper --version")
  end
end
