/* Shiny - Swimming App
   Sean Warlick
   March 16, 2017
*/
/* During exploration of the database we found that some of the women had "0" instead of "F" in the gender column.  This SQL was used to update the database.*/

Update Athlete

Set Gender = 'F'

Where Gender = '0'