function PP = GI_reflex(b, d, t)

PP_raw = (t)        ./ b^2 .* exp(-t       .^2  ./(2*b^2));
PP_max =  b         ./ b^2 .* exp(-b       .^2  ./(2*b^2));

PP = 1 + d * PP_raw / PP_max;