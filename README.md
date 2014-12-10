DNR
===

Download and Reset. Downloads the latest database and files from a Pantheon site and Resets your local dev environment. All in ONE command!

Requirments
====
### Pantheon Terminus

Install Pantheon Terminus: https://github.com/pantheon-systems/terminus

Here are the instructions reprinted for quick reference:

1.) Install Composer:

```curl -sS https://getcomposer.org/installer | php mv composer.phar /usr/local/bin/composer```

2.) Install Terminus:
```
# Download Terminus.
git clone https://github.com/pantheon-systems/terminus.git $HOME/.drush/terminus
# Download dependencies.
cd $HOME/.drush/terminus
composer update --no-dev
# Clear Drush's cache.
drush cc drush
```

###Daterbase

3.) Install Daterbase: https://github.com/Galavantier/daterbase

Installation
====
1.) Clone the Repo

```git clone git@github.com:Galavantier/DNR.git ./dnr```

2.) Make sure the Script has execute permissions

```chmod +x ./dnr/dnr.sh```

3.) Install the Script so that it is available on your command line. Note your bin directory may be different.

```ln -s ./dnr/dnr.sh ~/home/bin/dnr```

Usage
====
```dnr <pantheon_site_name> <path_to_site_code_directory> [<temp_directory>] [<database_name>]```

Arguments:
* pantheon_site_name : The machine name of the pantheon site
* path_to_site_code_directory : The path to the code (relative to the current directory)
* temp_directory (Optional) : The Directory where the backup files will be downloaded.
  * Note: By default the backup files will be downloaded in the current directory.
* database_name (Optional) : Explicitly tell the script what database name to use instead of infering based on the site name. 
