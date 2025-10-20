% minizinc --all-solutions --statistics day17.mzn
int: n = 20;
int: size = 150;
array[1..n] of int: container_sizes = [33, 14, 18, 20, 45, 35, 16, 35, 1, 13, 18, 13, 50, 44, 48, 6, 24, 41, 30, 42];
array[1..n] of var 0..1: use;
constraint sum(i in 1..n)(use[i] * container_sizes[i]) = size;

% solve satisfy; % part1
% part2 requires me to run twice, first with this to get the size:
var int: used_count = sum(i in 1..n)(use[i]);
%solve minimize used_count; % this first
constraint used_count = 4;
solve satisfy;

output [
  "Used containers: ", show([container_sizes[i] | i in 1..n where use[i] = 1]), "\n",
];