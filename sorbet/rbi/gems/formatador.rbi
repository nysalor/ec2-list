# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/formatador/all/formatador.rbi
#
# formatador-0.2.5
class Formatador
  def calculate_datum(header, hash); end
  def display(string = nil); end
  def display_compact_table(hashes, keys = nil, &block); end
  def display_line(string = nil); end
  def display_lines(lines = nil); end
  def display_table(hashes, keys = nil, &block); end
  def indent(&block); end
  def indentation; end
  def initialize; end
  def length(value); end
  def new_line; end
  def parse(string); end
  def progressbar(current, total, options); end
  def redisplay(string = nil, width = nil); end
  def redisplay_line(string = nil, width = nil); end
  def redisplay_progressbar(current, total, options = nil); end
  def self.display(*args, &block); end
  def self.display_compact_table(*args, &block); end
  def self.display_line(*args, &block); end
  def self.display_lines(*args, &block); end
  def self.display_table(*args, &block); end
  def self.indent(*args, &block); end
  def self.new_line(*args, &block); end
  def self.parse(*args, &block); end
  def self.redisplay(*args, &block); end
  def self.redisplay_line(*args, &block); end
  def self.redisplay_progressbar(*args, &block); end
  def strip(string); end
end
class Formatador::ProgressBar
  def complete?; end
  def current; end
  def current=(arg0); end
  def increment(increment = nil); end
  def initialize(total, opts = nil, &block); end
  def opts; end
  def opts=(arg0); end
  def total; end
  def total=(arg0); end
end
