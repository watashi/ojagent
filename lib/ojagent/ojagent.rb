require 'forwardable'
require 'mechanize'
require 'nokogiri'

module OJAgent
  class OJAgent
    extend Forwardable

    def_delegators :agent, :submit

    attr :retries, :duration

    attr_reader :agent, :base_uri, :languages

    def initialize(base_uri, languages)
      @agent = Mechanize.new
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

    def submit(pid, code, lang)
      raise NotImplementedError
    end

    def status(id)
      raise NotImplementedError
    end

    def submit!(pid, code, lang, retries = nil)
      retries ||= self.retries
      retries.times do
        begin
          ret = submit pid, code, lang
          return ret if ret
        rescue
        end
      end
      throw "Fail to submit"
    end

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
      throw "Fail to get status"
    end
  end
end
