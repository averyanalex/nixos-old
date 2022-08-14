{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      adnauseam
      foxyproxy-standard

      auto-tab-discard
      decentraleyes
      clearurls

      i-dont-care-about-cookies
      ipfs-companion
      bitwarden
    ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          # Disable "about:config" warn
          "browser.aboutConfig.showWarning" = false;

          # Remove import bookmarks button and remove default bookmarks
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # Overwrite welcome page
          "startup.homepage_welcome_url" = "https://nixos.org";

          # Disable auto update
          "app.update.checkInstallTime" = false;
          "app.update.auto" = false;

          # Strict protection
          "browser.contentblocking.category" = "standard";

          # Disable login saving
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;

          "browser.startup.homepage" = "https://search.nixos.org";
          "general.useragent.locale" = "en-US";
          "browser.search.region" = "RU";
          "browser.search.isUS" = false;

          # Alfis, I2P, tor TLD's
          "browser.fixup.domainsuffixwhitelist.mirror" = true;
          "browser.fixup.domainsuffixwhitelist.screen" = true;
          "browser.fixup.domainsuffixwhitelist.merch" = true;
          "browser.fixup.domainsuffixwhitelist.index" = true;
          "browser.fixup.domainsuffixwhitelist.onion" = true;
          "browser.fixup.domainsuffixwhitelist.anon" = true;
          "browser.fixup.domainsuffixwhitelist.conf" = true;
          "browser.fixup.domainsuffixwhitelist.ygg" = true;
          "browser.fixup.domainsuffixwhitelist.srv" = true;
          "browser.fixup.domainsuffixwhitelist.btn" = true;
          "browser.fixup.domainsuffixwhitelist.mob" = true;
          "browser.fixup.domainsuffixwhitelist.i2p" = true;

          # Yggdrasil tweaks
          "network.http.fast-fallback-to-IPv4" = false;
          "browser.fixup.fallback-to-https" = false;
          "browser.fixup.alternate.enabled" = false;
          "network.dns.disableIPv6" = false;

          # telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "datareporting.sessions.current.clean" = true;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.server_owner" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "";
        };
      };
    };
  };
}
