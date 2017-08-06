#!/bin/sh

if [ ! -d "$HOME/.gzn" ]; then
    platform='unknown'
    unamestr=$(uname)
    if [[ $unamestr == 'Linux' ]]; then
      platform='linux'
        hash git 2>/dev/null || { printf >&2 "unable to find git \n attempting to install with apt-get \n \n ";
        sudo apt-get install git; }
        hash ruby 2>/dev/null || { printf >&2 "unable to find ruby \n attempting to install ruby with apt-get \n \n";
        sudo apt-get install ruby; }
        hash rake 2>/dev/null || { printf >&2 "unable to find rake \n attempting to install rake\n \n";
        gem install rake; }
elif [[ $unamestr == 'Darwin' ]]; then
      platform='darwin'
        # check if homebrew is installed
        which -s brew
        if [[ $? != 0 ]]; then
            # Install Homebrew from source https://brew.sh/
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            brew update
        fi

        which -s git
        if [[ $? != 0 ]]; then
            brew install git
        else
            brew update
        fi

        which -s ruby
        if [[ $? != 0 ]]; then

            printf >&2 "installing ruby";
            brew install ruby;
            printf >&2 "installing rake";
            gem install rake;
        else
            which -s rake;
            if [[ $? != 0 ]]; then
                gem install ruby;
            else
                printf >&2 "all good";
            fi
        fi

    fi


    echo "Installing ross's dot files to .rcn"
    git clone --depth=1 https://github.com/rcnewman/.dot.git "$HOME/.rcn"
    cd "$HOME/.rcn"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
else
    echo "the directory .rcn already exists, to install or update cd ~/.rcn && rake update"
fi
