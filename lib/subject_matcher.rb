module SubjectMatcher
  def Post.parse_subject(subject_original)
    post = {}
    subject = subject_original
    # remove [Freecycle Bucuresti] heading
    match = subject.match /^\[Freecycle [^\]]*\] (.*)/
    if match
      subject = match[1]
    end
    # have kind?
    kinds = {
      'admin'             => 'admin',
      'offer'             => ['ofer', 'dau'],
      'offer_completed'   => 'dat',
      'request'           => 'caut',
      'request_completed' =>'luat'
    }

    expr = /\[?(#{kinds.values.flatten.join('|')})\]?(\:|\s)/i
    match = subject.match expr
    if (match)
      value = match[1].downcase
      post[:kind] = kinds.select{|k,v| v.include?(value)}.first[0]
      subject[expr] = ''
    end
    post[:subject] = subject.strip
    post[:subject_original] = subject_original
    return post
  end

  def Post.matches?(first, second)
    return false unless Post.pair_kind(first.kind) == second.kind
    first, second = second, first if Post::KIND_PAIRS.keys.include?(second.kind)
    return false unless first.sent_date <= second.sent_date
    Post.similarity(first.subject, second.subject) > 0
  end

  def Post.similarity(first, second)
    s1, s2 = simplify_subject(first), simplify_subject(second) 

    return 1 if s1 == s2

    s1, s2 = s2, s1 if s1.length > s2.length # s1 is the short one

    s1_words = s1.split(/\s+/).select{|word| word.length >= 3}
    s2_words = s2.split(/\s+/).select{|word| word.length >= 3}

    words = 0.0
    s1_words.each do |word|
      s2_words.each do |candidate|
        if word.length <= 4 && word == candidate || word.length > 4 && Text::Levenshtein.distance(word, candidate) <= 2
          words += 1
          break
        end
      end
    end

    return 0 if words / s1_words.size < 0.34
    words / s1_words.size + words / s2_words.size
  end

  def Post.simplify_subject(subject)
    s1 = subject.downcase
    s1.gsub!(/\([^)]*\)/, '')
    s1.gsub!(/\[[^\]]*\]/, '')
    s1.strip
  end
end
