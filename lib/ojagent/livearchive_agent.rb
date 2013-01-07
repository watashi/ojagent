module OJAgent
  class LiveArchiveAgent < OJAgent
    def initialize
      super 'http://icpcarchive.ecs.baylor.edu',
        :c      => '1',
        :java   => '2',
        :cpp    => '3',
        :pascal => '4'
    end

    def login(user, pass)
      @user = user
      page = get '/'
      login_form = page.form_with :id => 'mod_loginform'
      login_form.set_fields :username => user,
                            :passwd   => pass
      login_form.checkbox_with(:name => 'remember').check
      result = login_form.submit
    end

    def submit(pid, code, lang)
      page = get '/index.php?option=com_onlinejudge&Itemid=25'
      action = 'index.php?option=com_onlinejudge&Itemid=25&page=save_submission'
      submit_form = page.form_with :action => action
      submit_form.set_fields :localid  => pid,
                             :code     => code
      submit_form.radiobutton_with(
        :name => 'language', :value => languages[lang]).check
      result = submit_form.submit

      message = result / '.maincontent div.message'
      if message && message.inner_text =~ /Submission received with ID (\d+)/
        $1
      else
        nil
      end
    end

    @@selector = '.maincontent table tr'
    @@thead = [:id, :pid, :pname, :status, :lang, :time, :data]

    def status(id)
      url = '/index.php?option=com_onlinejudge&Itemid=9'
      parse_status url, @@selector, @@thead do |tr|
        !tr.empty? && tr[0].inner_text == id
      end
    end
  end
end
