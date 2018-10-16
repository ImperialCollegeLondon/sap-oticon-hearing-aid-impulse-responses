function[ir] = fcn_20181008_03_top_and_tail(ir)

monotonic_vec = cumsum(sum(abs(ir),2));
first_non_zero = sum(monotonic_vec<eps) + 1;
last_non_zero = sum(monotonic_vec<monotonic_vec(end)) + 1;
ir = ir(first_non_zero:last_non_zero,:);