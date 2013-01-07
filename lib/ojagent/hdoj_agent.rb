module OJAgent
  class HDOJAgent < OJAgent
    def initialize
      super 'http://acm.hdu.edu.cn',
        :cpp    => 0,
        :c      => 1,
        :mscpp  => 2,
        :msc    => 3,
        :pascal => 4,
        :java   => 5
    end

    def login(user, pass)
      @user = user
      page = get '/'
      login_form = page.form_with :action => '/userloginex.php?action=login'
      login_form.set_fields :username => user,
                            :userpass => pass
      login_form.submit
    end

    def submit(pid, code, lang)
      page = get '/submit.php'
      submit_form = page.form_with :action => './submit.php?action=submit'
      submit_form.set_fields :problemid  => pid,
                             :language   => languages[lang],
                             :usercode   => code
      submit_form.submit
      pid.to_s
    end

    @@selector = '#fixed_table table.table_text tr'
    @@thead = [:id, :date, :status, :pid, :time, :mem, :length, :lang, :user]

    def status(pid)
      parse_status '/status.php?user=' + user, @@selector, @@thead do |tr|
        tr[3] && tr[3].inner_text == pid
      end
    end
  end
end
