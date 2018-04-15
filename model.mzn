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
    flat[c] = dayOff /\ flat[c + 1] != dayOff ->
    forall (o in 1..minDaysWork) (flat[c + o] != dayOff)
);

% Ensures the maxiumum length of a day off block
constraint forall (c in Cells) (
    sum (o in 0..maxDaysOff) (bool2int(flat[c + o] != dayOff)) > 0
);

% Ensures the minimum length of a day of block
constraint forall (c in Cells) (
    flat[c] != dayOff /\ flat[c + 1] = dayOff ->
    forall (o in 1..minDaysOff) (flat[c + o] = dayOff)
);

% Ensures for every type of shift the maximum allowed concecutive shifts
constraint forall (shift in WorkShifts, c in Cells) (
    sum (o in 0..maxDaysShift[shift]) (bool2int(flat[c + o] != shift)) > 0
);

% Ensures for every type of shift the minimum allowed concecutive shifts
constraint forall (shift in WorkShifts, c in Cells) (
    flat[c] != shift /\ flat[c + 1] = shift ->
    forall (o in 1..minDaysShift[shift]) (flat[c + o] = shift)
);

% Ensures that no forbidden shift patterns of length two are present
constraint forall (c in Cells, i in ForbiddenShifts2) (
    flat[c] = forbiddenShifts2[i,1] -> flat[c + 1] != forbiddenShifts2[i,2]
);

% Ensures that no forbidden shift patterns of length three are present
constraint forall (c in Cells, i in ForbiddenShifts3) (
    flat[c] = forbiddenShifts3[i,1] /\ flat[c + 1] = dayOff ->
    flat[c + 2] != forbiddenShifts3[i,2]
);

% Ensures that on every day there are the right
% amount of employees in each shift
constraint forall (day in Days, shift in WorkShifts) (
   sum (e in Employees)
       (bool2int(schedule[e,day] = shift)) = requirements[shift, day] 
);

% REDUNDANT: Ensures that the right amount of employees have free on each day
% This is redundant and just used to improve the performance.
constraint forall (day in Days) (
   sum (e in Employees)
       (bool2int(schedule[e,day] = dayOff)) = dayOffRequirements[day] 
);

solve satisfy;

%
% Output 
% ---------
include "output.mzn";

