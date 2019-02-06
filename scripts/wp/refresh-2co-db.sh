#!/bin/bash

# Use previously-fetched tarball if one exists.
[[ ! -f '/tmp/wordpress.tgz' ]] && scp conweb-test:/tmp/wordpress.tgz /tmp/

tar xzvf /tmp/wordpress.tgz

mysql -u root -e 'drop database if exists final;' -e 'create database final;'
mysql -u root final < ./wordpress.sql

rm -vf wordpress.sql
