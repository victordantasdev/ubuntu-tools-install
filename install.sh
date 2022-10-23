#!/bin/bash

# colors
red='\e[1;91m'
green='\e[1;92m'
reset='\e[0m'

install() {
  clear

  # Update and upgrade
  sudo apt update && sudo apt full-upgrade -y
  sudo apt autoremove

  # install tools
  echo -e "${green}\nSTARTING INSTALATION PROCCESS...\n${reset}"
  PROGRAMS_TO_INSTALL=(
    vim
    zsh
    exa
    curl
    wget
    nano
    micro
    htop
    tmux
    neofetch
    flameshot
    flatpak
    gnome-software-plugin-flatpak
    ca-certificates
    gnupg
    lsb-release
    docker-ce
    docker-ce-cli
    containerd.io
    docker-compose-plugin
    build-essential
    software-properties-common
    apt-transport-https
  )

  for program_name in ${PROGRAMS_TO_INSTALL[@]}; do
    sudo apt install -y "$program_name"
    echo -e "${green} $program_name installed! ${reset}"
  done

  sudo apt update

  # install spaceship
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

  # set spaceship as zsh theme
  find ~/.zshrc -type f -exec sed -i 's/robbyrussell/spaceship/g' {} \;

  # adds aliases
  cat aliases.sh >>~/.zshrc

  # install zsh plugins
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  echo "\nzinit light zdharma-continuum/fast-syntax-highlighting" >>~/.zshrc
  echo "zinit light zsh-users/zsh-autosuggestions" >>~/.zshrc
  echo "zinit light zsh-users/zsh-completions" >>~/.zshrc
  source ~/.zshrc

  # install alacritty
  sudo add-apt-repository ppa:aslatter/ppa -y

  # copy config files
  cp -r .config ~/.config

  # config flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  # Config dev directory
  mkdir Dev && cd $_ &&
    mkdir -p \
      Work/Softaliza \
      GitHub \
      Studies \
      SideProjects \
      Lab/{NodeJS,OCaml,ReactJS,ReactNative,Clang,Rust,Ruby,Java,Clojure,Elixir,TypeScript,Go,Rust} &&
    cd

  # install nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
  echo '\nexport NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.zshrc
  source ~/.zshrc
  nvm i --lts
  npm i -g npm yarn pnpm softa-autocommit nodemon ts-node-dev http-server alacritty-themes

  # configure docker sock
  echo -e "${green} Configuring docker sock! ${reset}"
  sudo chmod 666 /var/run/docker.sock

  # install rust
  echo -e "${green} Installing Rust! ${reset}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source "$HOME/.cargo/env"

  # install erlang
  echo -e "${green} Installing Erlang! ${reset}"
  curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang.gpg

  # install clojure
  echo -e "${green} Installing Clojure! ${reset}"
  curl -O https://download.clojure.org/install/linux-install-1.10.2.774.sh
  chmod +x linux-install-1.10.2.774.sh
  sudo ./linux-install-1.10.2.774.sh

  # install ruby and ryby on rails
  # echo -e "${green} Installing Ruby and Ruby on Rails! ${reset}"
  # curl -sSL https://rvm.io/mpapis.asc | gpg --import - && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  # curl -L https://get.rvm.io | bash -s stable
  # source ~/.rvm/scripts/rvm
  # rvm requirements
  # rvm install ruby
  # rvm use ruby --default
  # rvm rubygems current
  # gem install rails
  # echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >>~/.zshrc

  # adds java ppa
  echo -e "${green} Adding Java PPA! ${reset}"
  sudo add-apt-repository ppa:openjdk-r/ppa -y

  # adds php ppa
  echo -e "${green} Adding PHP PPA! ${reset}"
  sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

  sudo apt update

  # install programming languages via apt
  LANGUAGES_TO_INSTALL=(
    opam
    rlwrap
    openjdk-18-jdk
    php8.1
    erlang
    elixir
    golang-go
  )

  for language_name in ${LANGUAGES_TO_INSTALL[@]}; do
    sudo apt install -y "$language_name"
    echo -e "${green} $language_name installed! ${reset}"
  done

  # configure ocaml
  opam init
  eval $(opam env --switch=default)
  opam install dune utop -y

  echo -e "${green}\n\nSCRIPT FINISHED WITH SUCCESS...\n${reset}"
}

# Script entry
install
