class Matcher
  def self.parse_by_author(posts)
    # group by author_md5
    by_author = {}
    posts.each do |p| 
      by_author[p.author_md5] = [] if !by_author.has_key?(p.author_md5)
      by_author[p.author_md5] << p
    end

    # which authors have more than one completion message
    authors = by_author.keys.select{|a| by_author[a].select{|p| Post::KIND_PAIRS.values.include?(p.kind)}.size > 0}
    authors.each{|author| parse_author(by_author[author])}
  end

  def self.parse_author(messages)
    # search for pairs with the same subject - and remove them
    while true do
      highest_score = 0
      best = nil
      by_kind = messages.partition{|p| Post::KIND_PAIRS.keys.include?(p.kind)}
      by_kind[0].each do |first|
        by_kind[1].each do |second|
          if Post.matches?(first, second)
            score = Post.similarity(first.subject, second.subject)
            if score > highest_score
              highest_score = score
              best = [first, second]
            end
          end
        end
      end
      if highest_score > 0
        best[0].pair = best[1]
        messages.delete(best[0])
        messages.delete(best[1])
      else
        break
      end
    end
  end

  posts = Post.without_pair(:conditions => {:kind => Post::KIND_MESSAGES})
  parse_by_author(posts)
end

