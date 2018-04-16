%
% Parameters
% ----------
include "parameters.mzn";

%
% Variables
% ---------

% The schedule gets one extra row to represent the cycling
array[1..(scheduleLength * (numberEmployees + 1))] of var Shifts: schedule;

% Ensures that the last week of the schedule version 
% equals the first week (for cycling)
constraint forall (d in Days) (
    schedule[d] = schedule[(scheduleLength * numberEmployees) + d]
);

% Ensures the maxiumum length of a work block
constraint forall (c in Cells) (
    sum (o in 0..maxDaysWork) (bool2int(schedule[c + o] = dayOff)) > 0
);

% Ensures the minimum length of a work block
constraint forall (c in Cells) (
    schedule[c] = dayOff /\ schedule[c + 1] != dayOff ->
    forall (o in 1..minDaysWork) (schedule[c + o] != dayOff)
);

% Ensures the maxiumum length of a day off block
constraint forall (c in Cells) (
    sum (o in 0..maxDaysOff) (bool2int(schedule[c + o] != dayOff)) > 0
);

% Ensures the minimum length of a day of block
constraint forall (c in Cells) (
    schedule[c] != dayOff /\ schedule[c + 1] = dayOff ->
    forall (o in 1..minDaysOff) (schedule[c + o] = dayOff)
);

% Ensures for every type of shift the maximum allowed concecutive shifts
constraint forall (shift in WorkShifts, c in Cells) (
    sum (o in 0..maxDaysShift[shift]) (bool2int(schedule[c + o] != shift)) > 0
);

% Ensures for every type of shift the minimum allowed concecutive shifts
constraint forall (shift in WorkShifts, c in Cells) (
    schedule[c] != shift /\ schedule[c + 1] = shift ->
    forall (o in 1..minDaysShift[shift]) (schedule[c + o] = shift)
);

% Ensures that no forbidden shift patterns of length two are present
constraint forall (c in Cells, i in ForbiddenShifts2) (
    schedule[c] = forbiddenShifts2[i,1] -> schedule[c + 1] != forbiddenShifts2[i,2]
);

% Ensures that no forbidden shift patterns of length three are present
constraint forall (c in Cells, i in ForbiddenShifts3) (
    schedule[c] = forbiddenShifts3[i,1] /\ schedule[c + 1] = dayOff ->
    schedule[c + 2] != forbiddenShifts3[i,2]
);

% Ensures that on every day there are the right
% amount of employees in each shift
constraint forall (day in Days, shift in WorkShifts) (
   sum (e in Employees)
       (bool2int(schedule[e * scheduleLength + day] = shift)) = requirements[shift, day] 
);

% REDUNDANT: Ensures that the right amount of employees have free on each day
% This is redundant and just used to improve the performance.
constraint forall (day in Days) (
   sum (e in Employees)
       (bool2int(schedule[e * scheduleLength + day] = dayOff)) = dayOffRequirements[day] 
);


% solve satisfy;
solve :: int_search(schedule, smallest, indomain_min, complete) satisfy;


%
% Output 
% ---------
include "output.mzn";

