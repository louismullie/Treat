# Allow comparison of entity hierarchy in DOM.
module Treat::Entities::Entity::Comparable

  # Determines whether the receiving class
  # is smaller, equal or greater in the DOM
  # hierarchy compared to the supplied one.
  def compare_with(klass)
    i = 0; rank_a = nil; rank_b = nil
    Treat.core.entities.order.each do |type|
      klass2 = Treat::Entities.const_get(type.cc)
      rank_a = i if self <= klass2
      rank_b = i if klass <= klass2
      next if rank_a && rank_b
      i += 1
    end
    return -1 if rank_a < rank_b
    return 0 if rank_a == rank_b
    return 1 if rank_a > rank_b
  end

end