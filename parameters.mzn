% Length of the schedule for a single employee
par int: scheduleLength;

% The total number of employees for which to find a schedule
par int: numberEmployees;

% The total number of different shifts employees can work in
par int: numberShifts;

% The minimum length of days-off blocks
par int: minDaysOff;

% The maximum length of days-off blocks
par int: maxDaysOff;

% The minimum length of work blocks
par int: minDaysWork;

% The maximum length of work blocks
par int: maxDaysWork;

% The names of the shifts - for visual representation
array[WorkShifts] of par string: shiftNames;

% The minimum amount of days a shift as to repeat itself
array[WorkShifts] of par int: minDaysShift;

% The maximum amount of days a shift is allowed to repeat itself
array[WorkShifts] of par int: maxDaysShift;

% The number of required employees for every shift and day
array[WorkShifts, Days] of par int: requirements;

% The set of forbidden shift combinations of length 2 - e.g. (N,D)
par int: numberForbiddenShifts2;
array[ForbiddenShifts2, 1..2] of par int: forbiddenShifts2;

% The set of forbidden shift combinations of length 3 - e.g. (N,N) which represents (N,-,N)
par int: numberForbiddenShifts3;
array[ForbiddenShifts3, 1..2] of par int: forbiddenShifts3;

set of int: Days             = 1..scheduleLength;
set of int: Employees        = 1..numberEmployees;
set of int: WorkShifts       = 1..numberShifts;
set of int: Shifts           = 0..numberShifts;
set of int: Cells            = 1..(scheduleLength * numberEmployees);
set of int: ForbiddenShifts2 = 1..numberForbiddenShifts2;
set of int: ForbiddenShifts3 = 1..numberForbiddenShifts3;

int: dayOff = 0;
string: dayOffLabel = "-";
array[Shifts] of par string: allShiftNames = array1d(Shifts, [dayOffLabel] ++ shiftNames);

% Represents the number of employees which have not to work on that day
% This is used for a redundant constraint to improve performance
array[Days] of int: dayOffRequirements =
    [numberEmployees - sum (s in WorkShifts) (requirements[s,d]) | d in Days];

%
% Asserts to ensure the parameters are sane
% -----------------------------------------

constraint assert(scheduleLength > 0, "The schedule length has to be positive");

constraint assert(numberEmployees > 0, "The number of employees has to be positive");

constraint assert(numberShifts > 0, "The number of shifts has to be positive");

constraint assert(
    minDaysOff > 0 /\ maxDaysOff >= minDaysOff,
    "Minimum and maximum length of day offs blocks are not correct"
);

constraint assert(
    minDaysWork > 0 /\ maxDaysWork >= minDaysWork,
    "Minimum and maximum length of work blocks are not correct"
);

constraint assert(forall (s in WorkShifts) (
    minDaysShift[s] > 0 /\ maxDaysShift[s] >= minDaysShift[s]
), "Minimum and maximum length of shift blocks are not correct");

constraint assert(forall (s in WorkShifts, d in Days) (
    requirements[s,d] >= 0
), "The requirements have to be non-negative");

constraint assert(forall (fs in ForbiddenShifts2) (
    forbiddenShifts2[fs,1] in WorkShifts /\ forbiddenShifts2[fs,2] in WorkShifts
), "The forbidden shifts patterns have to include proper shifts");

constraint assert(forall (fs in ForbiddenShifts3) (
    forbiddenShifts3[fs,1] in WorkShifts /\ forbiddenShifts3[fs,2] in WorkShifts
), "The forbidden shifts patterns have to include proper shifts");

