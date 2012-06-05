module SequenceServer
  module Test
    module Env
      PACKAGE = "ncbi-blast-2.2.26+"
      ARCHIVE = "#{PACKAGE}-ia32-linux.tar.gz"
      URL     = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/#{ARCHIVE}"

      extend self

      def setup
        install_blast
        install_gem
        generate_config
      end

      private

      def download_blast
        system("wget #{URL}")
      end

      def extract_blast
        system("tar xvf #{ARCHIVE}")
      end

      def generate_config
        FileUtils.touch(File.expand_path("~/.sequenceserver.conf"))
      end

      def blast_installed?
        system('blastp -h > /dev/null 2> /dev/null')
      end

      def install_blast
        unless blast_installed?
          download_blast and extract_blast
        end
      end

      def gem_installed?
        # FIXME: must check version (local system may have outdated gem installed)
        system('sequenceserver -h > /dev/null 2> /dev/null')
      end

      def install_gem
        unless gem_installed?
          system('gem install sequenceserver')
        end
      end
    end

    module Server
      extend self

      def run_from_gem
        run('sequenceserver')
      end

      def run_from_source
        run("#{File.join(File.dirname(__FILE__), '..', 'bin', 'sequenceserver')}")
      end

      def kill
        Process.kill('TERM', @pid)
        sleep 2 # pre shutdown cleanup can take some time
      end

      private

      def run(command)
        @pid = fork {
          ENV['PATH']     = "#{Env::PACKAGE}/bin:" + ENV['PATH']
          ENV['RACK_ENV'] = 'test'
          exec(command)
        }
        sleep 5 # wait for server to launch
      end
    end

    module Client
      extend self

      def http
        obj = Net::HTTP.new('localhost', 4567)
        obj.read_timeout = 5
        obj
      end

      def ping
        status = http.head('/') rescue nil
        status and status.code.to_i
      end
    end
  end
end
