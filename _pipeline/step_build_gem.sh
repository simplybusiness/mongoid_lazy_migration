#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e

gem_deploy mongoid_lazy_migration.gemspec
