module OJAgent
  class HDOJAgent < OJAgent
    attr_reader :user

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

    def logout
    end

    def submit(pid, code, lang)
      page = get '/submit.php'
      submit_form = page.form_with :action => './submit.php?action=submit'
      submit_form.set_fields :problemid  => pid,
                             :language   => languages[lang],
                             :usercode   => code
      submit_form.submit
      [user, pid]
    end

    def status(id)
      user, pid = *id
      page = get '/status.php?user=' + user
      status = (page / '#fixed_table table.table_text tr').
        map{|tr| tr / 'td'}.
        find{|td| td[3] && td[3].inner_text == pid.to_s}

      return nil unless status
      ret = {}
      ths = [:id, :date, :status, :pid, :time, :mem, :length, :lang, :user]
      ths.each_with_index do |k, i|
        ret[k] = status[i].inner_text.strip.gsub('\s+', ' ')
      end
      url = status[3] / 'a[href]'
      ret[:url] = url.map{|a| a['href']} unless url.empty?
      ret
    end
  end
end
