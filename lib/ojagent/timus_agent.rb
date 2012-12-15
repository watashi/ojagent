module OJAgent
  class TimusAgent < OJAgent
    attr_accessor :user, :pass

    def initialize
      super 'http://acm.timus.ru',
        :pascal => '3',
        :java   => '7',
        :c      => '9',
        :cpp    => '10',
        :cs     => '11'
    end

    def login(user, pass)
      self.user = user
      self.pass = pass
    end

    def logout
    end

    def submit(pid, code, lang)
      page = get '/submit.aspx'
      submit_form = page.form_with :action => 'submit.aspx?space=1'
      submit_form.set_fields :JudgeID    => user + pass,
                             :Language   => languages[lang],
                             :ProblemNum => pid,
                             :Source     => code
      submit_form.submit
      pid
    end

    def status(pid)
      page = get '/status.aspx?author=' + user
      status = (page / 'table.status tr').
        map{|tr| tr / 'td'}.
        find{|td| td[3] && td[3].inner_text.start_with?(pid)}

      return nil unless status
      ret = {}
      ths = [:id, :date, :user, :pname, :lang, :status, :testid, :time, :mem]
      ths.each_with_index do |k, i|
        ret[k] = status[i].inner_text.strip.gsub('\s+', ' ')
      end
      if ret[:pname] =~ /^(\d+).\s*(.*)$/
        ret[:pid] = $1
        ret[:pname] = $2
      end
      url = status[5] / 'a[href]'
      ret[:url] = url.map{|a| a['href']} unless url.empty?
      ret
    end
  end
end
