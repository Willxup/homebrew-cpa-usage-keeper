class CpaUsageKeeper < Formula
  desc "Standalone CPA usage persistence and dashboard service"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  license "MIT"
  version "2.0.2"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v2.0.2/cpa-usage-keeper_v2.0.2_darwin_arm64.tar.gz"
      sha256 "2a3fc4d275ef752b691bb21d62344a1269c6924e32fde9575bba5d212091a05b"
    end

    on_intel do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v2.0.2/cpa-usage-keeper_v2.0.2_darwin_amd64.tar.gz"
      sha256 "f49304766eebde490c4d58d553fb8ebe26c975687ebd31910a8036c591f7295f"
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

      Required values include CPA_BASE_URL and CPA_MANAGEMENT_KEY. LOGIN_PASSWORD is also required unless authentication is explicitly disabled.

      Start the service with:

        brew services start cpa-usage-keeper
    EOS
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/cpa-usage-keeper --help 2>&1")
  end
end
