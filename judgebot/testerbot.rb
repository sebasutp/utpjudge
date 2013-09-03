require 'httparty'
require 'json'
require 'httmultiparty'

class SConsumer
  
#  include HTTParty
#  format :json
#  basic_auth 'user', 'password'

  include HTTMultiParty
  base_uri 'http://localhost:3000'

end

class Testerbot
  @@lang = { 'cpp'=>1, 'c'=>2, 'java'=>3, 'py'=>4 }

  def send(exe_pro,file)
    ext = file.split('.')[1]
    ur  = "/submissions/testerbot.json"
    res = SConsumer.post(ur, :query => {
      :language_id => @@lang[ext],
      :exercise_problem_id => exe_pro,
      :submission => {:srcfile => File.new(file)}
    })

    return res[0]
  end

  def run(path,ntimes,t)
    if path[-1]=='/'
      path = path[0,path.length-1]
    end    
    
    problems = Dir[ path + '/*' ].map { |a| File.basename(a) }
    path2 = path + '/'
    ntimes.times do |x|
      for p in problems
        subs = Dir[ path2 + p + '/*' ].map { |a| File.basename(a) }
        path3 = path2 + p + '/'
        for f in subs
          exec_pro = f.split('.')[0].split('_')[1]
          t1 = Time.now
          req = send(exec_pro,path3+f)
          t2 = Time.now
          puts t2-t1
          sleep t
        end
      end
    end
  end
end

tb = Testerbot.new
# Usage: <path sources>  <send N times every source>  <delay between every submission>
tb.run('test',1,0)
