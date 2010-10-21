module StatsHelper
  def chart_range(values)
    0..values.flatten.max
  end

  def chart_image(url, wh)
    image_tag url, {:alt => (t 'stats.loading'), :width => wh[0], :height => wh[1] }
  end
end
