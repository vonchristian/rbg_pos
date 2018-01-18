module WillPaginateHelper
  class ProductRootedLinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = ""
        target = "/products?page=#{target}"
      end
      attributes[:href] = target
      tag(:a, text, attributes)
    end
  end
  class StoreRootLinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = ""
        target = "/store?page=#{target}"
      end
      attributes[:href] = target
      tag(:a, text, attributes)
    end
  end
   class ProductStocksRootedLinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = ""
        target = "/products?page=#{target}"
      end
      attributes[:href] = target
      tag(:a, text, attributes)
    end
  end
end
