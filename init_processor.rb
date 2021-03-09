require_relative 'lib/card_processor'

unless ARGV[0].nil?
  entries = File.read(ARGV[0])
else
  entries = ARGF.read
end

card_processor = CardProcessor.new(entries.split(/\n+/))

card_processor.process_entry

card_processor.display_statement
