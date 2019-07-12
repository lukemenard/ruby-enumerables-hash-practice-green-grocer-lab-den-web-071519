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
  clean_cart = consolidate_cart(cart)
  coupons.each do |coupon| 
    coupon.each do |attribute, value| 
      item = coupon[:item] 
      if clean_cart[item] && clean_cart[item][:count] >= coupon[:num] 
        if clean_cart["#{item} W/COUPON"] 
          clean_cart["#{item} W/COUPON"][:count] += coupon[:num] 
        else
          clean_cart["#{item} W/COUPON"] = {:price => coupon[:cost], 
          :clearance => clean_cart[item][:clearance], :count => coupon[:num]} 
          clean_cart["#{item} W/COUPON"][:price] = (clean_cart["#{item} W/COUPON"][:price] / coupon[:num])
        end 
      clean_cart[item][:count] -= coupon[:num]
    end 
  end 
end 
  clean_cart 
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
