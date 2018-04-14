%
% Parameters
% ----------
include "parameters.mzn";

%
% Variables
% ---------
array[Employees, Days] of var Shifts: schedule;
array[Cells] of var Shifts: scheduleFlat;

constraint forall (e in Employees, d in Days) (schedule[e,d] = scheduleFlat[e * d]);

solve satisfy;

%
% Output 
% ---------
include "output.mzn";

