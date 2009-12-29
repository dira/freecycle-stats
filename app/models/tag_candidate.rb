class TagCandidate < ActiveRecord::Base
  STATUSES = ["yes", "no"]
  enum_field "status", STATUSES, :allow_nil => true

  def self.candidates
    candidates = Post.all(:select => :subject).map{|p| p.subject}.join(' ').downcase.split(/\W/).uniq.sort
    checked = TagCandidate.all(:select => :word, :conditions => { :status => STATUSES }).map{|t| t.word }
    candidates = candidates - checked
    # get x results that are words in the dictionary
    result = []
    candidates.each do |word|
      if valid?(word)
        result << word
        break if result.size == 50
      else
        # add it in the dictionary as a non-tag
        TagCandidate.create(:word => word, :status => "no")
      end
    end
    result
  end

  def self.valid?(word)
    ActiveRecord::Base.establish_connection

    #XXX awful hack to quickly get around wtf and romanian char encoding
    word = word[0..0].gsub(/(s|t|i)/, '_') + word[1..-1].gsub(/(s|t|a|i)/, '_')

    sql = sanitize_sql_array(["SELECT wl_neaccentuat FROM dex.words WHERE wl_neaccentuat LIKE '%s'", word]) 
    result = ActiveRecord::Base.connection.execute(sql).fetch_row
    return result
  end
end
