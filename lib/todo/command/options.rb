require 'optparse'

module Todo
  class Command
    module Options
      def self.parse!(argv)
        sub_command_parsers=Hash.new do |k,v|
          raise ArgumentError,"'#{v}' is not todo sub command."
        end

        sub_command_parsers{'create'}=OptionParser.new do |opt|
          opt.on('-n VAL','--name=VAL','task name'){|v| options[:name]=v}
          opt.on('-c VAL','--content=VAL','task content'){|v| options[:content]=v}
        end

        command_parser=OptionParser.new do |opt|
          opt.on_head('-v','--version','Show program version') do |v|
            opt.version=Todo::VERSION
            puts opt.ver
            exit
          end
        end





      def self.create_sub_command_parsers
        sub_command_parsers=Hash.new do |k,v|
          raise ArgumentError,"'#{v}' is not todo sub command."
        end

        sub_command_parsers['create']=OptionParser.new do |opt|
          opt.on('-n VAL','--name=VAL','task name'){|v| options[:name]=v}
          opt.on('-c VAL','--content=VAL','task content'){|v| options[:content]=v}
        end

        sub_command_parsers['search']=OptionParser.new do |opt|
          opt.on('-s VAL','--status=VAL','search name'){|v| options[:name]=v}
        end

        sub_command_parsers['update']=OptionParser.new do |opt|
          opt.on('-n VAL','--name=VAL','update name'){|v| options[:name]=v}
          opt.on('-c VAL','--content=VAL','update content'){|v| options[:content]=v}
          opt.on('-s VAL','--status=VAL','update status'){|v| options[:status]=v}
        end

        sub_command_parsers['delete']=OptionParser.new do |opt|
        end
      end

      def self.parse!(argv)
        options={}

        sub_command_parsers = create_sub_command_parsers
        command_parser=create_command_parser

        begin
          command_parser.order!(argv)
          options[:command]=argv.shift
          sub_command_parsers[options[:command]].parse!(argv)

          if %w(update delete).include?(options[:command])
            raise ArgumentError,"#{options[:command]} id not found." if argv.empty?
            options[:id]=Integer(argv.first)
          end
        rescue OptionParser::MissingArgument,OptionParser::InvalidOption,ArgumentError=>e
          abort e.message
        end
        options
      end

      def self.create_command_parser
        OptionParser.new do |opt|
          opt.on_head('-v','--version','Show program version') do |v|
            opt.version = Todo::VERSION
            puts opt.ver
            exit
          end
        end
      end
    end
  end
end

