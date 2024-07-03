#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'activesupport', '= 7.0.4'
  gem 'pry', '= 0.14.1'
  gem 'git', '>= 2.1.1'
end

require 'yaml'
require 'pry'
require 'active_support/all'

MADEK_DIR= Pathname.new(File.dirname(File.absolute_path(__FILE__))).join("..").to_s
CONFIG_DIR= File.absolute_path("#{MADEK_DIR}/config")

def main
  madek_git = Git.open(MADEK_DIR)
  current_commit = madek_git.log.first

  datalayer_git = Git.open(MADEK_DIR+"/datalayer")
  datalayer_current_commit = datalayer_git.log.first


  IO.write("#{CONFIG_DIR}/deploy-info.yml",
           {tree_id: current_commit.gtree.sha,
            commit_id: current_commit.sha,
            datalayer_tree_id: datalayer_current_commit.gtree.sha,
            datalayer_commit_id: datalayer_current_commit.sha,
            url: madek_git.remote.url,
            deploy_time: Time.now.utc.as_json
           }.as_json.to_yaml)

end

main()
