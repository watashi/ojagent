module OJAgent
  class CLIAgent < OJAgent
    def initialize
      super 'http://icpcarchive.ecs.baylor.edu',
        :c      => '1',
        :java   => '2',
        :cpp    => '3',
        :pascal => '4'
    end

    def login(user, pass)
      page = get '/'
      login_form = page.form_with :id => 'mod_loginform'
      login_form.set_fields :username => user,
                            :passwd   => pass
      login_form.checkbox_with(:name => 'remember').check
      result = login_form.submit
    end

    def logout
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

    def status(id)
      page = get '/index.php?option=com_onlinejudge&Itemid=9'
      status = (page / '.maincontent table tr').
        map{|tr| tr / 'td'}.
        find{|td| !td.empty? && td[0].inner_text == id}

      return nil unless status
      ret = {
        :id     => status[0].inner_text,
        :pid    => status[1].inner_text,
        :pname  => status[2].inner_text,
        :status => status[3].inner_text.strip,
        :lang   => status[4].inner_text,
        :time   => status[5].inner_text,
        :date   => status[6].inner_text
      }
      url = status[3] / 'a[href]'
      ret[:url] = url.map{|a| a['href']} unless url.empty?
      ret
    end
  end
end
