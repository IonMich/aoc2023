filename = "inputs\input.txt";
lines = readlines(filename);
vals_str = char(lines);
A = readtable(filename, "Delimiter", " ");
color_codes = A{:,"Var3"};
loc = [0; 0];
area = 0;
exteriorPoints = 0;
for idx_code=1:length(color_codes)
    code_cell = color_codes(idx_code);
    code_str = code_cell{1,1};
    [dir, step] = code2vec(code_str);
    dr = step * dir;
    locFlipped = [-loc(2);loc(1)];
    area = area + dr*locFlipped;
    loc = loc + transpose(dr);
    exteriorPoints = exteriorPoints + step;
end
% Green's Theorem
area = area / 2;
% Pick's Theorem
fprintf('%d\n', abs(area)+exteriorPoints/2+1)

function [dir, step] = code2vec(code_str)
    hex_code = strip(strip(code_str,"left",'('),"right",')');
    last_char = hex_code(:,end);
    switch last_char
        case "0"
            dir = [1, 0];
        case "1"
            dir = [0, -1];
        case "2"
            dir = [-1, 0];
        case "3"
            dir = [0, 1];
    end
    step_hex = hex_code(:,2:end-1);
    step_hex = upper(step_hex);
    step = hex2dec(step_hex);
end
