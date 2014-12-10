#!/bin/bash

# wait animation
spinner()
{
  local pid=$1
  local delay=0.05
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Download and Reset the Database to the Latest Backup

if [ "$#" -eq 0 ]; then
  echo -e "Download and Reset"
  echo -e "Usage: dnr <pantheon_site_name> <path_to_site_code_directory> [<temp_directory>] [<database_name>]\n"
  exit 0
fi

site_name="$1"
site_uuid=$(drush psite-uuid "${site_name}" | sed 's/'"$site_name"": "//)

site_code_dir="$2"
if [ "$site_code_dir" = "" ]
  then
  echo -e "Must specify the Site Code Directory.\n"
  exit 0
fi

if [ "$3" = "" ]
  then
  echo -e "No temporary download directory specified. Using the current directory.\n"
  temp_dir="./"
else
  echo -e "Using $3 as the temporary download directory.\n"
  temp_dir="$3"
fi

# get the database.
echo -e "Downloading the Database..."
(drush psite-dl-backup "${site_uuid}" live latest database "${temp_dir}") &
spinner $!
database_zip=$(find ./ -name "*database*" | sed 's#.*/##')

# get the files.
echo -e "Downloading the Files..."
(drush psite-dl-backup "${site_uuid}" live latest files "${temp_dir}") &
spinner $!
files_zip=$(find ./ -name "*files*" | sed 's#.*/##')

# extract the database.
echo -e "Unzipping the Database SQL file..."
(gunzip "${database_zip}") &
spinner $!

# extract the files.
echo -e "Unzipping the Files Directory..."
(tar xvzf "${files_zip}") &
spinner $!

database_file=$(find ./ -name "*database*.sql" | sed 's#.*/##')

echo -e "\nSetting Permissions and moving the files directory to sites/default/files.\n"
mv files_live files
sudo chmod -R 777 files
sudo rm -R "${site_code_dir}/sites/default/files/"
sudo mv files "${site_code_dir}/sites/default/"

echo -e "Running Reset Database and Set Dev Mode.\n"
if [ "$4" = "" ]
  then
  reset_database "${database_file}" -m "${site_code_dir}/utilities/set_dev_mode.sh"
else
  echo -e "Using $4 as the database name.\n"
  reset_database "${database_file}" -d "$4" -m "${site_code_dir}/utilities/set_dev_mode.sh"
fi

echo -e "Cleaning up.\n"
rm "${site_name}"*.gz
rm "${database_file}"
