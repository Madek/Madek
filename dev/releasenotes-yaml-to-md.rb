#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'

CONFIG_DIR = './config'

releases = YAML.safe_load(File.read("#{CONFIG_DIR}/releases.yml"))['releases']

textfiles = releases.map do |rel|
  version = "#{rel['version_major'].to_i}.#{rel['version_minor'].to_i}.#{rel['version_patch'].to_i}"
  if pre = rel['version_pre'] then version = "#{version}-#{pre}" end

  text = <<~TXT
    ---
    version_major: #{rel['version_major'].to_i}
    version_minor: #{rel['version_minor'].to_i}
    version_patch: #{rel['version_patch'].to_i}
    version_pre: #{rel['version_pre'] || 'null'}
    name: '#{rel['name']}'
    info_url: '#{rel['info_url']}'
    ---

    #{rel['description'].strip}

  TXT

  [version, text]
end

textfiles.each do |version, text|
  FileUtils.mkdir_p("#{CONFIG_DIR}/releases/")
  File.write("#{CONFIG_DIR}/releases/#{version}.md", text)
end
