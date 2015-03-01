#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "opscode-chef-mover"
default_version "2.2.20"

source git: "http://github.com/chef/chef-mover"

dependency "erlang"
dependency "rebar"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command 'sed -i "s;git@github.com:opscode;https:\/\/github.com/chef;g" rebar.config'
  command 'sed -i "s;git@github.com:opscode;https:\/\/github.com/chef;g" rebar.config.lock'
  command 'sed -i "s;git@github.com:;https:\/\/github.com/;g" rebar.config.lock'
  command 'sed -i "s;a16918da46a39a3d0791889f61f62b1265955d8d;d16a4fd968e000b65e4678cccfad68d7a0a8bd1c;g" rebar.config.lock'

  make "distclean", env: env
  make "rel", env: env

  sync "#{project_dir}/rel/mover/", "#{install_dir}/embedded/service/opscode-chef-mover/"
  delete "#{install_dir}/embedded/service/opscode-chef-mover/log"

  mkdir "#{install_dir}/embedded/service/opscode-chef-mover/scripts"
  copy "scripts/migrate", "#{install_dir}/embedded/service/opscode-chef-mover/scripts/"
  copy "scripts/check_logs.rb", "#{install_dir}/embedded/service/opscode-chef-mover/scripts/"
  command "chmod ugo+x #{install_dir}/embedded/service/opscode-chef-mover/scripts/*"
end
