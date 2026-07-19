// Enable User Customizationser
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("layout.css.color-mix.enabled", true);
user_pref("layout.css.backdrop-filter.enabled", true);

// Browser
user_pref("browser.warnOnQuitShortcut", false);

// Tabs
user_pref("browser.tabs.loadBookmarksInTabs", true);
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
user_pref("zen.view.show-clear-tabs-button", false);

// New Tab
user_pref("zen.urlbar.replace-newtab", false);
user_pref("zen.view.show-newtab-button-top", false);
user_pref("zen.tabs.show-newtab-vertical", false);
user_pref("browser.tabs.insertRelatedAfterCurrent", true);

// Graphics & Performance Tuning
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("general.smoothScroll", true);
user_pref("mousewheel.default.delta_multiplier_y", 100);

// Telemetry & Privacy Hardening
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.ping-centre.telemetry", false);

// Zen Specific UI & Accent Preferences
user_pref("zen.workspaces.show-workspace-indicator", true);
