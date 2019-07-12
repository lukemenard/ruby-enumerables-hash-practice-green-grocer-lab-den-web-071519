def consolidate_cart(cart)
  clean_cart = {}
  cart.each do |item|
    item.each do |key, value|
      if clean_cart[key]
        clean_cart[key][:count] += 1
      else
        clean_cart[key] = value
        clean_cart[key][:count] = 1
      end
    end
  end
  clean_cart
end

def apply_coupons(cart, coupons)
  hash = cart
  coupons.each do |coupon_hash|
    # add coupon to cart
    item = coupon_hash[:item]

    if !hash[item].nil? && hash[item][:count] >= coupon_hash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_hash[:cost],
        :clearance => hash[item][:clearance],
        :count => 1
        }
      }
      
      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += 1
        #hash["#{item} W/COUPON"][:price] += coupon_hash[:cost]
      end
      
      hash[item][:count] -= coupon_hash[:num]
    end
  end
  hash
end

def apply_clearance(cart)
  cart.each do |item, hash|
    if hash[:clearance] == true
      hash[:price] = (hash[:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total_price = 0
  clean_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(clean_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  clearance_cart.each do |item, hash|
    total_price =+ (hash[:count] * hash[:price])
  end
  if total_price > 100
    total_price = total_price*0.9
  end
  total_price
end
