IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_loadFaculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_loadFaculty]
as
begin




SELECT    distinct    concat(E.Employee_FName,'' '',E.Employee_LName) AS empname,
           E.Employee_Mail, 
                        E.Employee_Id
FROM           Tbl_Employee E
						 where 
						 E.Employee_Status=0
						--E.Employee_Type =''Teaching''

						 end

    ');
END;
