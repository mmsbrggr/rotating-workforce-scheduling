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
