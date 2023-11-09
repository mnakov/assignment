#!/bin/bash

# Navigate to the sites directory
cd web/sites

# Loop through each site
for site in *; do
  # Ensure the site directory is not the special directories "." or ".."
  if [ "$site" != "." ] && [ "$site" != ".." ]; then
    # Check that settings.php exists for this site
    if [ -f "$site/settings.php" ]; then
      # Navigate to the Drupal directory and run the Drush command for the site
      echo "Generating static site for: $site"
      lando drush tome:static --uri=http://$site
    fi
  fi
done
