%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'cellarray');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using ODBC driver.
conn = database('buoyweather_prediction', '', '');

%Read data from database.
curs = exec(conn, ['SELECT 	`cuaca maritim`.id'...
    ' ,	`cuaca maritim`.`h1`'...
    ' ,	`cuaca maritim`.`h2`'...
    ' ,	`cuaca maritim`.`h3`'...
    ' ,	`cuaca maritim`.`h4`'...
    ' ,	`cuaca maritim`.`h5`'...
    ' ,	`cuaca maritim`.`h6`'...
    ' ,	`cuaca maritim`.`h7`'...
    ' FROM 	`buoyweather_predicition`.`cuaca maritim` ']);

curs = fetch(curs);
close(curs);

%Assign data to output variable
untitled = curs.Data;

%Close database connection.
close(conn);

%Clear variables
clear curs conn