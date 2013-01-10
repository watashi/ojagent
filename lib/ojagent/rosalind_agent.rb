module OJAgent
  class RosalindAgent < OJAgent
    def initialize
      super 'http://rosalind.info'
    end

    def login(user, pass)
      @user = user
      page = get '/accounts/login/'
      login_form = page.form_with :id => 'id_form_login'
      login_form.set_fields :username => user,
                            :password => pass
      login_form.submit
    end

    def open(pid)
      get "/problems/#{pid}/dataset/"
    end

    def submit(pid, ans, src = nil)
      page = get "/problems/#{pid}/"
      submit_form = page.form_with :id => 'id_form_submission'
      submit_form.file_upload_with(:name => 'output_file').file = ans
      submit_form.file_upload_with(:name => 'code').file = src if src
      submit_form.submit
    end

    @@close = "\xc3\x97".force_encoding('utf-8')

    def status(page)
      status = {}
      [:error, :warning, :info, :success].each do |type|
        messages = []
        (page / "div.main div.alert-#{type}.flash-message").each do |alert|
          message = alert.inner_text.strip.gsub(@@close, '').gsub(/\s+/, ' ')
          messages << message unless message.empty?
        end
        status[type] = messages unless messages.empty?
      end
      status[:status] = status[:success] && !status[:error] ? 'Correct' : 'Wrong'
      status
    end
  end
end
