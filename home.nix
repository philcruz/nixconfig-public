{ config, pkgs, ... }:

{
  home = {
    username = "phil";
    homeDirectory = "/Users/phil";
    # Specify packages not explicitly configured below
    packages = with pkgs; [
      autojump
      aws-iam-authenticator
      aws-vault
      awscli2
      bun
      bash-my-aws
      duti
      fzf
      hurl
      kubectl
      kubectx
      pulumi-bin
      ripgrep
      tmux
    ];

    file.".gitignore_global".source = ./gitignore_global;
    file.".aws/config".source = ./aws/config;

    #file.".bashrc".source = ./bashrc;
    #file.".bash_profile".source = ./bash_profile;
    file.".config/nix/nix.conf".source = ./nix/nix.conf;
    file.".steampipe/config/aws.spc".source = ./steampipe/config/aws.spc;
    file.".steampipe/config/bitbucket.spc".source = ./steampipe/config/bitbucket.spc;
    file.".steampipe/config/default.spc".source = ./steampipe/config/default.spc;
    file.".steampipe/config/googlesheets.spc".source = ./steampipe/config/googlesheets.spc;
    file.".steampipe/config/jira.spc".source = ./steampipe/config/jira.spc;
    file.".steampipe/config/jira_pmi.spc".source = ./steampipe/config/jira_pmi.spc;
    file.".steampipe/config/slack.spc".source = ./steampipe/config/slack.spc;
    file.".steampipe/config/snowflake.spc".source = ./steampipe/config/snowflake.spc;
    file.".steampipe/config/steampipe.spc".source = ./steampipe/config/steampipe.spc;
    file.".steampipe/graphpad-steampipe-912ba11865f2.json".source = ./steampipe/graphpad-steampipe-912ba11865f2.json;


    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Replacement for cat
  programs.bat.enable = true;

  # Navigate directory trees
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };
  
  # Replacement for ls
  programs.eza = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      aws-login = "aws sso login --profile is-master";
      hmb = "home-manager switch -b backup";
      #ll = "ls -l"; use exa instead
      multipull = "find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \\;";
      nix-build-work = "nix build .#darwinConfigurations.Karambit.system";
      nix-build-m1 = "nix build .#darwinConfigurations.Kodachi.system";
      nix-build-home = "nix build .#darwinConfigurations.Katana.system";
      nix-up = "./result/sw/bin/darwin-rebuild switch --flake .";
      "ssh-philcruz.com" = "ssh ubuntu@philcruz.com";
      "ssh-dev1.snapgene.com" = "ssh -i '~/GraphPad Software Dropbox/Phil Cruz/AWS/accounts/prodops-dev/SnapGeneDev.pem' ubuntu@dev1.snapgene.com";
      "ssh-staging1.snapgene.com" = "ssh -i '~/GraphPad Software Dropbox/Phil Cruz/AWS/accounts/prodops-dev/SG-Staging-Key-Pair.pem' ubuntu@staging1.snapgene.com";
      "ssh-web1.snapgene.com" = "ssh phil@web1.snapgene.com";
      "ssh-scheduler" = "ssh -i '~/GraphPad Software Dropbox/Phil Cruz/AWS/accounts/prodops-prod/scheduler.insightfulscience.com.pem' ubuntu@ec2-54-165-129-27.compute-1.amazonaws.com";
      "vscode-settings-backup" = "cp '/Users/phil/Library/Application Support/Code/User/settings.json' ~/nixconfig/backup/vscode-settings.json";
      "vscode-settings-compare" = "bcomp '/Users/phil/Library/Application Support/Code/User/settings.json' ~/nixconfig/backup/vscode-settings.json";
    };

    #dirHashes = {
    #  dl    = "$HOME/Downloads";
    #};

    initExtraFirst = ''
     # Fig pre block. Keep at the top of this file.
     [[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
    '';

    initExtra = ''
    ${builtins.readFile ./awschrome.txt}

    #make sure brew is on the path for M1 
    if [[ $(uname -m) == 'arm64' ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else 
       export NVM_DIR="$HOME/.nvm"
      [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    fi

     # Fig post block. Keep at the bottom of this file.
    [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
    '';

    profileExtra = ''
      # Fig pre block. Keep at the top of this file.
      [[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"

      # Fig post block. Keep at the bottom of this file.
      [[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [  
        "autojump"
        "kubectl"
       ];
    theme = "robbyrussell";
  };
  
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [      
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "coder-remote";
        publisher = "coder";
        version = "0.1.18";
        sha256 = "1861gi3rqm2zwc88b6y041rhxv87k24w2p34d6hry6xgxik4d0xj";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.5.0";
        sha256 = "1hngv5224jxgffxzm85qbkjgxgb25lihz9kzscmwdq6hrqaxsq5b";
      }
      {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      }
      {
        name = "theme-dracula";
        publisher = "dracula-theme";
        version = "2.24.2";
        sha256 = "1bsq00h30x60rxhqfdmadps5p1vpbl2kkwgkk6yqs475ic89dnk0";
      }
      {
        name = "vscode-cfml";
        publisher = "KamasamaK";
        version = "0.5.4";
        sha256 = "1zhfmica92ys0z2vwp174wpi6fh2ddc79y3hqz205a8hibi9l0sc";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.25.1";
        sha256 = "1r0h6mi339gbczz3rrr1k2hfxk6w9f1pvpf4lrclp670nldfch5w";
      }    
      {
        name = "xml";
        publisher = "DotJoshJohnson";
        version = "2.5.1";
        sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
  }
    ];
  };

}
