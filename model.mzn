%
% Parameters
% ----------
include "parameters.mzn";

%
% Variables
% ---------
array[Employees, Days] of var Shifts: schedule;
% The flat version gets one extra row to represent the cycling
array[1..(scheduleLength * (numberEmployees + 1))] of var Shifts: flat;

% Makes sure that the schedule and the flat version of the schedule represent the same thing
constraint forall (e in Employees, d in Days) (
    schedule[e,d] = flat[((e - 1) * scheduleLength) + d]
);

% Ensures that the last week of the flat version 
% equals the first week (for cycling)
constraint forall (d in Days) (
    flat[1 * d] = flat[(scheduleLength * numberEmployees) + d]
);

% Ensures the maxiumum length of a work block
constraint forall (c in Cells) (
    sum (o in 0..maxDaysWork) (bool2int(flat[c + o] = dayOff)) > 0
);

% Ensures the minimum length of a work block
constraint forall (c in Cells) (
    (flat[c] = dayOff /\ flat[c + 1] != dayOff) ->
    forall (o in 1..minDaysWork) (flat[c + o] != dayOff)
);

% Ensures the maxiumum length of a day off block
constraint forall (c in Cells) (
    sum (o in 0..maxDaysOff) (bool2int(flat[c + o] != dayOff)) > 0
);

% Ensures the minimum length of a day of block
constraint forall (c in Cells) (
    (flat[c] != dayOff /\ flat[c + 1] = dayOff) ->
    forall (o in 1..minDaysOff) (flat[c + o] = dayOff)
);

solve satisfy;

%
% Output 
% ---------
include "output.mzn";

