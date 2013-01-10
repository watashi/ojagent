require 'forwardable'
require 'mechanize'
require 'nokogiri'

class Mechanize::Form::FileUpload
  def file=(file, default_name = 'noname')
    data, name = *file
    self.file_data = data
    self.file_name = name || default_name
  end
end

module OJAgent
  class LoginFailureError < RuntimeError
  end

  class OperationFailureError < RuntimeError
  end

  class OJAgent
    extend Forwardable

    def_delegators :agent, :submit

    attr_accessor :retries, :duration

    attr_reader :agent, :base_uri, :languages, :user

    def initialize(base_uri = nil, languages = {})
      @agent = Mechanize.new
      @agent.open_timeout = 20
      @agent.read_timeout = 60
      @base_uri = base_uri
      @languages = languages
      @retries = 10
      @duration = 2
    end

    def get(uri, parameters = [], referer = nil, headers = {})
      agent.get base_uri + uri, parameters, referer
    end

    def post(uri, query={}, headers={})
      agent.post base_uri + uri, query, headers
    end

    def login(user, pass)
      raise NotImplementedError
    end

    def logout
      raise NotImplementedError
    end

    def open(pid)
      # noop
    end

    def submit(pid, code, lang)
      raise NotImplementedError
    end

    def status(id)
      raise NotImplementedError
    end

    def parse_status(url, selector, thead, &block)
      tbody = get(url) / selector
      tr = tbody.map{|tr| tr / 'td'}.find{|tr| yield tr}
      return nil unless tr

      ret = {}
      thead.zip(tr) do |th, td|
        next unless th && td
        ret[th] = td.inner_text.strip.gsub(/\s+/, ' ')
        if th == :status
          url = td / 'a[href]'
          if url.size > 0
            ret[:url] = (ret[:url] || []) + url.map{|a| a['href']}
          end
        end
      end
      ret
    end

    # Open the problem or download the input. For online judges that ask
    # users to download the input and upload the output in time limit,
    # user must open (download the input) before submit (upload the output).
    # For other online judges, it does nothing.
    def open!(pid, retries = 1)
      retries ||= self.retries
      retries.times do
        begin
          ret = open pid
          return ret if ret
        rescue
        end
      end
      raise OperationFailureError, "Fail to open"
    end

    # Submit solution and retry on failure. The return value is a hint for
    # getting status and varys at different online judges.
    def submit!(pid, code, lang, retries = nil)
      retries ||= self.retries
      retries.times do
        begin
          ret = submit pid, code, lang
          return ret if ret
        rescue
        end
      end
      raise OperationFailureError, "Fail to submit"
    end

    # Get status and retry on failure.
    def status!(id, retries = nil, duration = nil)
      retries ||= self.retries
      duration ||= self.duration
      ret = nil
      retries.times do
        begin
          ret = status id
          if ret &&
             ret[:status] &&
             ret[:status] =~ /[a-z]/i &&
             ret[:status] !~ /sent to judge|(?:pend|queu|compil|link|runn|judg)ing/i
            return ret
          end
        rescue
        end
        sleep duration
      end
      return ret if ret
      raise OperationFailureError, "Fail to get status"
    end

    # Submit solution and get the corresponding status.
    def judge!(pid, code, lang, retries = nil, duration = nil)
      id = submit!(pid, code, lang, retries)
      status!(id, retries, duration)
    end
  end
end
