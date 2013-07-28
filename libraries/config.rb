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
      @options.merge!(new_options) if new_options.kind_of?(Hash)
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
        IO.write(@file, "<?php\n$CONFIG = #{data};\n")
        Chef::Log.info("OwnCloud config written")
      rescue Exception => e
        Chef::Application.fatal!("Error writting OwnCloud config: #{e.message}")
      end
    end
  end
end
