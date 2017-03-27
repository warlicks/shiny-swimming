/* Shiny-Swimming App
   Update Meet Dates
   Sean Warlick
   March 26, 2017
*/ 

/* During data exploration I discovered that SQLite was not understanding the format of the dates as they are currently loaded into the database.  This series of Updates will correct this problem.
*/


/* Update where month is a single diget*/
UPDATE MEET

SET
	 MEET_DATE = Case When Instr(MEET_DATE, '/') = 2 Then '0'||MEET_DATE ELSE MEET_DATE END
;

/*Update so the day of the month is always 2 digets*/
UPDATE Meet

SET
	MEET_DATE = CASE
					WHEN Instr(Substr(MEET_DATE, 4), '/') = 2 
						Then Substr(MEET_DATE, 1, 3)||'0'||SUBSTR(MEET_DATE, 4)
					ELSE MEET_DATE
				END
;

/* Change string so it follow 'YYYY-MM-DD'*/
UPDATE MEET

Set MEET_DATE = SUBSTR(MEET_DATE, 7)||'-'||SUBSTR(MEET_DATE, 1, 2)||'-'||SUBSTR(MEET_DATE, 4, 2)
;
