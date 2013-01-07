module OJAgent
  class TimusAgent < OJAgent
    def initialize
      super 'http://acm.timus.ru',
        :pascal => '3',
        :java   => '7',
        :c      => '9',
        :cpp    => '10',
        :cs     => '11'
    end

    def login(user, pass)
      @user = user
      @pass = pass
    end

    def submit(pid, code, lang)
      page = get '/submit.aspx'
      submit_form = page.form_with :action => 'submit.aspx?space=1'
      submit_form.set_fields :JudgeID    => user + @pass,
                             :Language   => languages[lang],
                             :ProblemNum => pid,
                             :Source     => code
      submit_form.submit
      pid.to_s
    end

    @@selector = 'table.status tr'
    @@thead = [:id, :date, :user, :pname, :lang, :status, :testid, :time, :mem]

    def status(pid)
      url = '/status.aspx?author=' + user
      status = parse_status url, @@selector, @@thead do |tr|
        tr[3] && tr[3].inner_text.start_with?(pid)
      end
      if status[:pname] =~ /^(\d+).\s*(.*)$/
        status[:pid], status[:pname] = $1, $2
      end
      status
    end
  end
end
