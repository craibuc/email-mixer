#!/usr/bin/env ruby

#
# Author: Craig Buchanan
#
# Revions:
#
#   01/20/2014 - created
#   02/05/2014 - added patterns; added '-m' option; ' OR ' delimiter

require 'optparse'
require 'ostruct'

class App
  
  VERSION = '0.1.0'
  DELIMITERS = {:comma =>",", :semicolon=>";", :space=>" ", :or=>" OR "}
  
  attr_reader :options, :parser
  
  def initialize(args)

    @arguments = args
    
    @elements = OpenStruct.new
    
    @options = OpenStruct.new
    @options.output = :console
    @options.delimiter = :comma
    @options.middle_initial = false
    @options.verbose = false

    @parser = OptionParser.new do |opts|
      
      opts.banner = "Usage: ./mix.rb [options] domain first_name last_name [middle_initial]"
      opts.separator ""
      opts.separator "Specific options:"

      # Optional argument with keyword completion.
      opts.on("-d", "--delimiter [DELIMITER]", [:comma, :semicolon, :space, :or], "Select delimiter (comma, semicolon, space, or)") do |d|
        options.delimiter = d
      end

      # Optional argument with keyword completion.
      opts.on("-o", "--output [OUTPUT]", [:clipboard, :console], "Select output (clipboard, console)") do |o|
        options.output = o
      end

      # Boolean switch.
      opts.on("-m", "--middle-initial", "Force creation of middle-initial patterns using letters a through z") do |d|
        options.middle_initial = true
      end
      
      # Boolean switch.
      opts.on("-V", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("-v", "--version", "Show version") do
        puts "#{File.basename(__FILE__)} version #{VERSION}" #::Version.join('.')
        exit
      end
            
    end # do

    begin
      @parser.parse!(args)
      options
    rescue OptionParser::InvalidOption => e
      puts e
      puts " "
      puts parser
      exit (1)
    end
  
  end # parse()
  
  def run

    puts "Start at #{DateTime.now}\n\n" if @options.verbose
    
    output_options if @options.verbose # [Optional]
    
    if @arguments.length>=3 then
      process_arguments
      process_command
    else
      puts @parser
    end
    
    puts "\nFinished at #{DateTime.now}" if @options.verbose

  end
  
  protected
  
    def output_options
      
      puts "Options:\n"
    
      @options.marshal_dump.each do |name, val|        
        puts "  #{name} = #{val}"
      end
      
    end
  
    def process_arguments
  
      @elements.domain = @arguments.shift
      @elements.first_name = @arguments.shift
      @elements.last_name = @arguments.shift
      @elements.middle_name = @arguments.shift
      
      puts "Arguments:\n  #{@elements}" if @options.verbose
      
    end # process_arguments

    def process_command

      d = @elements.domain.downcase
      # puts "d: #{d}"
      fn = @elements.first_name.gsub(/\s+/, "").downcase
      # puts "fn: #{fn}"
      ln = @elements.last_name.gsub(/\s+/, "").downcase
      # puts "ln: #{ln}"
      mn = @elements.middle_name.gsub(/\s+/, "").downcase if @elements.middle_name
      # puts "mn: #{mn}"
      
      # patterns
      addresses = []

      # first onlny
      addresses << "#{fn}@#{d}"           # first@domain

      # first, last variations
      addresses << "#{fn}.#{ln}@#{d}"     # first.last@domain
      addresses << "#{fn}#{ln}@#{d}"      # firstlast@domain
      addresses << "#{fn[0]}#{ln}@#{d}"   # flast@domain
      addresses << "#{fn}#{ln[0]}@#{d}"   # firstl@domain
      
      # last, first variations
      addresses << "#{ln}.#{fn}@#{d}"     # last.first@domain
      addresses << "#{ln}#{fn}@#{d}"      # lastfirst@domain
      addresses << "#{ln}#{fn[0]}@#{d}"   # lastf@domain

      if mn then
      
        # first, middle, last variations
        addresses << "#{fn}.#{mn}.#{ln}@#{d}"       # first.middle.last@domain
        addresses << "#{fn}#{mn}#{ln}@#{d}"         # firstmiddlelast@domain
        addresses << "#{fn}.#{mn[0]}.#{ln}@#{d}"    # first.m.last@domain
        addresses << "#{fn}#{mn[0]}#{ln}@#{d}"      # firstmlast@domain
        addresses << "#{fn[0]}#{mn[0]}#{ln}@#{d}"   # fmlast@domain    
        addresses << "#{fn}#{mn[0]}#{ln[0]}@#{d}"   # firstml@domain
      
        # last, first, middle variation
        addresses << "#{ln}#{fn[0]}#{mn[0]}@#{d}"   # lastfm@domain
      
        # create 26 variations of first.middle.last
      elsif (@options.middle_initial || !mn)
        
        ("a".."z").each{|letter| 
          addresses << "#{fn}.#{letter}.#{ln}@#{d}"       # first.X.last@domain
        }
        
      end
      
      # 
      puts addresses.join(DELIMITERS[@options.delimiter]) if @options.output==:console
      IO.popen('pbcopy', 'w').puts addresses.join(DELIMITERS[@options.delimiter]) if @options.output==:clipboard
      
    end # process_command
  
end # class App

app = App.new(ARGV)
app.run
