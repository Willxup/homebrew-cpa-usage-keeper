class CpaUsageKeeper < Formula
  desc "Standalone CPA usage persistence and dashboard service"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  license "MIT"
  version "1.11.3"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v1.11.3/cpa-usage-keeper_v1.11.3_darwin_arm64.tar.gz"
      sha256 "36c5bb804ba0e1b0583e2db483d749891af03719c376e5d19fe55b264f274009"
    end

    on_intel do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v1.11.3/cpa-usage-keeper_v1.11.3_darwin_amd64.tar.gz"
      sha256 "2fbe895237bba6c9598f5b27c599646ceb91a2eb34aa554ba6af362c5e580d42"
    end
  end

  def install
    inreplace ".env.example", "WORK_DIR=./data", "WORK_DIR=#{var}/cpa-usage-keeper"

    bin.install "cpa-usage-keeper"
    etc.install ".env.example" => "cpa-usage-keeper.env.example"
    pkgshare.install "README.md", "README.zh.md", "LICENSE"
  end

  def post_install
    (var/"cpa-usage-keeper").mkpath

    env_file = etc/"cpa-usage-keeper.env"
    cp etc/"cpa-usage-keeper.env.example", env_file unless env_file.exist?
  end

  service do
    run [opt_bin/"cpa-usage-keeper", "--env", etc/"cpa-usage-keeper.env"]
    working_dir var/"cpa-usage-keeper"
    keep_alive true
    log_path var/"log/cpa-usage-keeper.log"
    error_log_path var/"log/cpa-usage-keeper.err.log"
  end

  def caveats
    <<~EOS
      Edit the configuration before starting the service:

        #{etc}/cpa-usage-keeper.env

      Required values include CPA_BASE_URL and CPA_MANAGEMENT_KEY.

      Start the service with:

        brew services start cpa-usage-keeper
    EOS
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/cpa-usage-keeper --help 2>&1")
  end
end
