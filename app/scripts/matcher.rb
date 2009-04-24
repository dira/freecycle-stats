require 'pp'

class Matcher
  Group.all.each do |group|
    pp "Parsing: #{group.name}"
    posts = group.posts.all(:conditions => {:pair_id => nil, :kind => Post::KIND_PAIRS.flatten})
    pp "#{posts.size} unmatched posts"
    # group by author_md5
    by_author = {}
    posts.each do |p| 
      by_author[p.author_md5] = [] if !by_author.has_key?(p.author_md5)
      by_author[p.author_md5] << p
    end

    nr_matches = 0
    # which authors have more than one message?
    by_author.keys.select{|a| by_author[a].size > 1}.each do |author|
      messages = by_author[author]
      # search for pairs with the same subject - and remove them
      while true do
        match_found = false
        messages.each do |first|
          break if match_found

          messages.each do |second|
            break if match_found

            if Post.are_pair?(first, second)
              match_found = true
              nr_matches += 1

              first.set_pair(second)

              messages.delete(first)
              messages.delete(second)
            end
          end
        end
        break if !match_found
      end
    end
    pp "#{nr_matches} matches"
  end
end

