require "json"
require "pry"

module Dotfiles
  module Vim
    class PluginInstaller
      attr_reader :out, :err, :path

      def initialize io_out, io_err, path, config_file
        @out         = io_out
        @err         = io_err
        @path        = path
        @config_file = config_file
      end

      def install
        config = JSON.parse File.read 

        config["github"].each do |plugin|
          final_path = File.join path, plugin.split("/").last

          out.puts "Cloning #{plugin}..."
          %x(git clone #{depth} git://github.com/#{plugin} #{final_path})
          out.puts "Done!"
        end

        out.puts "All plugins were installed."
      end

      def depth
        "--depth 1"
      end
    end
  end
end

Dotfiles::Vim::PluginInstaller.new(
  STDOUT,
  STDERR,
  Dir.home,
  "./plugins"
).install
