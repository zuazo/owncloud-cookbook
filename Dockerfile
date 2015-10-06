FROM zuazo/chef-local:debian-7

COPY . /tmp/owncloud
RUN berks vendor -b /tmp/owncloud/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[owncloud]"

EXPOSE 80

CMD ["apache2", "-D", "FOREGROUND"]
