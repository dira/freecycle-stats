module Matcher
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

  def Post.similarity(first, second)
    s1, s2 = simplify_subject(first), simplify_subject(second) 

    return 1 if s1 == s2

    distance = Text::Levenshtein.distance(s1, s2)
    lengths = [s1.length, s2.length]
    sure_distance = lengths.max - lengths.min

    return false unless distance - sure_distance < lengths.min / 5

    return -distance
  end

  def Post.simplify_subject(subject)
    s1 = subject.downcase
    s1.gsub!(/\([^)]*\)/, '')
    s1.strip
  end
end
