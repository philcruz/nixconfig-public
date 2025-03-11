{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  system.stateVersion = 4;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];

  nixpkgs.config.allowUnfree = true; 
  users.users.phil = {
    name = "phil";
    home = "/Users/phil";
  };

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation.autoUpdate = false; 
  };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "bruno"
    "cleanmymac"
    "http-toolkit"
    "pulsar"
    "rectangle"
    "visual-studio-code"
    "vlc"
  ];

  homebrew.brews = [
    "chamber"
    "coder"
    "deno"
    "k9s"
    "mas"
    "nvm"
    "parallel"
    "powerpipe"
    "pulumi"
    "sops"
    "steampipe"
  ];

  homebrew.masApps = {
    "Microsoft Remote Desktop" = 1295203466;
    "Slack for Desktop" = 803453959;
    Xcode = 497799835;
  };


  # Custom scripts
  # Add new scripts to the array!
  environment.systemPackages = 
    let 
    hello-world = pkgs.writeShellScriptBin "hello-world" ''
      ${builtins.readFile ./scripts/hello-world.sh}
    '';
    set-default-app = pkgs.writeScriptBin "set-default-app" ''
      ${builtins.readFile ./scripts/set-default-app.sh}
    '';
    update-installed-exts = pkgs.writeScriptBin "update_installed_exts" ''
      ${builtins.readFile ./scripts/update_installed_exts.sh}
    '';
    generate-credentials-report = pkgs.writeScriptBin "generate-credentials-report" ''
      ${builtins.readFile ./scripts/generate-credentials-report.sh}
    '';
  in 
  [ 
    hello-world
    generate-credentials-report
    set-default-app
    update-installed-exts
  ];

  # https://github.com/nix-community/home-manager/issues/423
  #environment.variables = {
  #  TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  #};
  programs.nix-index.enable = true;

  # Fonts
  #fonts.enableFontDir = true;
  #fonts.fonts = with pkgs; [
  #   recursive
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

  # Keyboard
  #system.keyboard.enableKeyMapping = true;
  #system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  #security.pam.enableSudoTouchIdAuth = true;

}