#!/bin/bash

# Request user input
echo "Please enter domain:"
read domain
echo "Please enter site name:"
read sitename
echo "Please enter default language (e.g. en):"
read deflang
echo "Please enter other languages, comma-separated (e.g. fr,es):"
read otherlangs

# Configure .lando.yml for the new site
sed -i '' -e "/appserver:/a\\
    - $domain" .lando.yml

sed -i '' -e "/services:/a\\
  $sitename-static:\\
    type: php\\
    webroot: ./web/static/$sitename" .lando.yml

sed -i '' -e "/services:/a\\
  $sitename:\\
    type: mysql\\
    creds:\\
      user: $sitename\\
      password: $sitename\\
      database: $sitename" .lando.yml

sed -i '' -e "/proxy:/a\\
  $sitename-static:\\
    - static.$domain" .lando.yml


# Create folder for the new site
mkdir web/sites/$domain

# Create settings file
cp web/sites/default/default.settings.php web/sites/$domain/settings.php

# Add the configuration folder setting
echo "\$settings['config_sync_directory'] = '../config/$sitename/';" >> web/sites/$domain/settings.php
echo "\$settings['tome_files_directory'] = 'static/$sitename/files';" >> web/sites/$domain/settings.php
echo "\$settings['tome_content_directory'] = 'static/$sitename/content';" >> web/sites/$domain/settings.php
echo "\$settings['tome_static_directory'] = 'static/$sitename';" >> web/sites/$domain/settings.php

# Add record for the new site in sites.php
echo "\$sites['$domain'] = '$domain';" >> web/sites/sites.php

# Add the new host to /etc/hosts
echo "Adding new host to /etc/hosts..."
echo "127.0.0.1       $domain" | sudo tee -a /etc/hosts
echo "127.0.0.1       static.$domain" | sudo tee -a /etc/hosts

lando rebuild -y

cd web/sites/$domain

# Install Drupal with selected default language
lando drush si --db-url=mysql://$sitename:$sitename@$sitename/$sitename --site-name="$sitename" --locale=$deflang

# Install language and translation modules
lando drush en config_translation -y
lando drush en content_translation -y

# Install Tome
lando drush en tome_static -y

# Add other languages
IFS=","
for lang in $otherlangs
do
    lando drush language-add $lang
done

# Clear all caches
lando drush cr

# Export configurions for newly created site
lando drush cex -y


