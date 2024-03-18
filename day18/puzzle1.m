filename = "inputs\input.txt";
lines = readlines(filename);
vals_str = char(lines);
A = readtable(filename, "Delimiter", " ");
dirs = A{:,"Var1"};
stepsizes = A{:,"Var2"};
colours = A{:,"Var3"};
loc = [0; 0];
area = 0;
exteriorPoints = 0;
for idx_step=1:length(stepsizes)
    dir_str = dirs(idx_step);
    dir = dir2vec(dir_str);
    step = stepsizes(idx_step);
    dr = step * dir;
    locFlipped = [-loc(2);loc(1)];
    area = area + dr*locFlipped;
    loc = loc + transpose(dr);
    exteriorPoints = exteriorPoints + step;
end
% Green's Theorem
area = area / 2;
% Pick's Theorem
disp(abs(area)+exteriorPoints/2+1)

function [vec] = dir2vec(dir)
    switch dir{1}
        case "R"
            vec = [1, 0];
        case "D"
            vec = [0, -1];
        case "L"
            vec = [-1, 0];
        case "U"
            vec = [0, 1];
    end
end
