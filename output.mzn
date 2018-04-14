output [ if d == 1 then show_int(2, e) ++ ". " else "" endif
         ++ allShiftNames[fix(schedule[e,d])]
         ++ if d == scheduleLength then "\n" else " " endif
       | e in Employees, d in Days]
