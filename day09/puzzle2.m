lines = readlines("inputs\input.txt");
vals_str = char(lines);
vals = str2num(vals_str); %#ok<ST2NM>
vals = int32(vals);
val_dims = size(vals);
max_diff_order = val_dims(2)-1;
iter = 1;
last_vals = zeros(val_dims);
last_vals(:,1) = vals(:,val_dims(2));
while any(vals,'all')
    vals = diff(vals, 1, 2);
    val_dims = size(vals);
    iter = iter + 1;
    last_vals(:,iter) = vals(:,val_dims(2));
end
extrapolated = cumsum(last_vals,2);
result = sum(extrapolated(:,end));
fprintf('%d\n',result)