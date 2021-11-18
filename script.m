function [] = loop_script(sim, loop_code)

addpath(genpath('/users/dscott3/projects/chp-basic-int'))
run_param_loop

fname = ['sim_', num2str(sim), '_code_', num2str(loop_code), '.mat'];
save(fname)

end
