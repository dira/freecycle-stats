class TagCandidate < ActiveRecord::Base
  belongs_to :category

  STATUSES = ["yes", "no"]
  enum_field "status", STATUSES, :allow_nil => true

  validates_presence_of :word
  validates_uniqueness_of :word

  named_scope :tags, { :conditions => { :status => "yes" } }
  named_scope :uncategorized, { :conditions => { :category_id => nil } }
  named_scope :limited, lambda { |number| { :limit => number } }

  def self.candidates
    candidates = Post::all_words_in_subjects(Post.messages(:select => :subject))
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
