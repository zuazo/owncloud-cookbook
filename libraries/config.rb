require 'json'

module OwnCloud
  class Config
    attr_reader :options

    def initialize(file)
      @file = file
      @options = Hash.new
      @original_options = Hash.new
      read
    end

    def [](index)
      @options[index]
    end

    def merge(new_options)
      return unless new_options.respond_to?(:to_hash)
      new_options = new_options.to_hash
      # remove not set values
      new_options.reject!{|k, v| v.nil?}
      # merge options overriding collisions with new values
      @options.merge!(new_options) do |key, v1, v2|
        # make an union on array values
        if v1.kind_of?(Array) and v2.kind_of?(Array)
          v1|v2
        # exotic case: mantain original dbtype when sqlite3 driver is available
        elsif key == 'dbtype' and v1 == 'sqlite3' and v2 == 'sqlite'
          v1
        else
          v2
        end
      end
    end

    def read()
      begin
        return unless ::File.exists?(@file)
        f = IO.popen('php', 'r+')
        f.write "<?php require('#{@file}'); echo json_encode($CONFIG);"
        f.close_write
        data = f.read
        f.close
        @options = JSON.parse(data)
        @original_options = @options.clone
      rescue Exception => e
        Chef::Application.fatal!("Error reading OwnCloud config: #{e.message}")
      end
    end

    def write()
      begin
        return if @options == @original_options
        f = IO.popen('php', 'r+')
        f.write "<?php var_export(json_decode('#{@options.to_json}', true));"
        f.close_write
        data = f.read
        f.close
        File.open(@file, 'w') do |f|
          f.write "<?php\n$CONFIG = #{data};\n"
        end
        Chef::Log.info("OwnCloud config written")
      rescue Exception => e
        Chef::Application.fatal!("Error writting OwnCloud config: #{e.message}")
      end
    end
  end
end
