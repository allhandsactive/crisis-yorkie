#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/vendor/interface-reflector/rake-like'
# puts "\e[5;35mruby-debug\e[0m"; require 'rubygems'; require 'ruby-debug'

# The purpose of this file is really just to keep in version control
# meta-information about resources that we neither want to keep in
# version control themselves, nor use git submodules for.

# the copy-paste source for some of this is the (node.js) project fap-doc

task :check do |o|
  o.desc "Renders an attractive and popular report",
           "to show what is and isn't installed."
  o.execute do
    ::LibrariesTableRenderer.render(self.parent.subcommands, @c.out)
  end
end

task :"jquery-ui-zipfile" do |o|
  o.task_class WgetTask
  o.category "jquery"
  o.desc 'put the zipfile in cwd'
  o.host 'jqueryui.com'
  o.url '/download/jquery-ui-1.8.11.custom.zip'
  o.dest './{url_basename}'
  o.interface { |i| i.on '-n', '--dry-run', 'dry run' }
  o.note "now do this: unzip ./jquery-ui-1.8.11.custom.zip -d public/javascripts/"
end

false and
task :"jquery-1.5.2-min" do |o|
  o.task_class WgetTask
  o.category "jquery"
  o.desc 'put the minified jquery in {dest}'
  o.host 'code.jquery.com'
  o.url '/jquery-1.5.2.min.js'
  o.dest "#{File.dirname(__FILE__)}/vendor/jquery-1.5.2.min.js"
  o.interface { |i| i.on '-n', '--dry-run', 'dry run' }
end

# code here was copy-pasted from fap-doc.   it is copy-pasted to mininmize
# coupling, because it is just a bootstrapping script and sometimes it is nice
# to see all the code here.

module AhaVote
  class TaskCommon < Hipe::InterfaceReflector::TaskDefinition
    attr_akksessor :category, :dest, :note
    class << self
      def deactivate!
        @active = false;
      end
      def active?
        instance_variable_defined?('@active') ? @active : true
      end
    end
    def dest_dir
      dest.sub(/\.tar\.gz$/,'')
    end
    def dest_dirname_basename
      File.basename(File.dirname(dest))
    end
    def show_note
      note and @c.err.puts(color("note: ",:yellow) <<
        [note].flatten.join("\n"))
      true
    end
  end

  class GitTask < TaskCommon
    attr_akksessor :src
    def execute
      @c.err.puts %x{git clone #{src} #{dest}}
      show_note
    end
  end

  class HgTask < TaskCommon
    attr_akksessor :src
    def execute
      cmd = "hg clone #{src} #{dest}"
      @c.out.puts color("running with exec!: ", :yellow) << cmd
      show_note
      exec cmd
    end
  end

  class WgetTask < TaskCommon
    attr_akksessor :host, :url, :port
    def execute
      these = [host, url, dest]
      these.index(nil).nil? and return wget(*these)
      fail("I CAINT")
    end
    def wget host, url, dest
      require 'net/http'
      File.exist?(dest) and return @c.err.puts("exists: #{dest}")
      @c.err.print "getting http://#{host}#{port}#{url}\n"
      len = 0;
      if ! @c.key?(:dry_run) || ! @c[:dry_run]
        File.open(dest, 'w') do |fh|
          res = Net::HTTP.start(host) do |http|
            http.get(url) do |str|
              @c.err.print '.'
              len += str.size
              fh.write str
            end
          end
        end
      end
      @c.err.puts "\nwrote #{dest} (#{len} bytes)."
      note and @c.err.puts(color("note: ",:yellow) <<
        [note].flatten.join("\n"))
      true
    end
    def dest_dirname_basename;          File.basename(File.dirname(dest)) end
    def dest_basename;                                File.basename(dest) end
    def url_basename;                                  File.basename(url) end
  end

  module LibrariesTableRenderer
    extend Hipe::InterfaceReflector::Colorizer
    extend self
    def render cmds, out
      require File.dirname(__FILE__)+'/vendor/interface-reflector/omni-table'
      cat_list = []
      cats = Hash.new { |h, k| cat_list.push(k); h[k] = [] }
      cmds.select{ |c| c.respond_to?(:category) }.each do |c|
        cats[c.category].push(c)
      end
      # cats.values.each { |ls| ls.sort! { |a,b| a.name <=> b.name } }
      tbl = []
      cat_list.each do |cat|
        tbl.empty? or tbl.push(['','','']).push(['','',''])
        tbl.push [
          { :value => " * #{color(cat, :bright, :green)} * ",
            :align => :left  }, '', '' ]
        cats[cat].each do |c|
          di = c.subcommand_documenting_instance
          status_msg = if (:not_applicable == di.dest)
                               color('n/a', :green)
          elsif File.exists?(di.dest_dir)
            if c.active? then  color('installed:',     :green)
            else               color('mehnstalled:',   :yellow) end
          elsif c.active? then color('not installed:', :dark_red)
          else                 color('meh:',           :yellow) end
          status_str = if (:not_applicable == di.dest)
                               '(n/a)'
          else                 di.dest_dir end
          tbl.push([ c.name, status_msg, status_str])
        end
      end
      ::Hipe::InterfaceReflector::OmniTable.new(tbl,
        [{:align => :right},{:align => :right},{:align => :left}]).
        sep(' ').no_headers!.to_ascii(out)
    end
  end
end
include AhaVote
