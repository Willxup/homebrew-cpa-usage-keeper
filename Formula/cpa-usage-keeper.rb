class CpaUsageKeeper < Formula
  desc "Standalone CPA usage persistence and dashboard service"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  license "MIT"
  version "2.0.0"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v2.0.0/cpa-usage-keeper_v2.0.0_darwin_arm64.tar.gz"
      sha256 "a040b6fa68d27f0fd5efb7463c5bdcdf5a5ee45a33322593b9dabe53d3d94c4e"
    end

    on_intel do
      url "https://github.com/Willxup/cpa-usage-keeper/releases/download/v2.0.0/cpa-usage-keeper_v2.0.0_darwin_amd64.tar.gz"
      sha256 "031a1ef9f3e99142f0b977688da7634b5198082ea606f24ed6cb967f5193fbe6"
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
