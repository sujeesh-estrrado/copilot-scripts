IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Substitute_Teachers_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Substitute_Teachers_By_Date]     
        @From_Date datetime,      
        @To_Date datetime                    
        AS                  
        BEGIN    
          
            SELECT  
                TS.Teacher_Substituition_Id AS ID,  
                TS.Week_Day_Id AS WeekDay_Settings_Id,    
                TS.Class_Timings_Id,  
                TS.Employee_In_Leave_Id,  
                E.Employee_FName + '' '' + E.Employee_LName AS AbsentEmployee,  
                EE.Employee_FName + '' '' + EE.Employee_LName AS SubstituteEmployee,  
                TS.Employee_Substitute_Id,  
                TS.Leave_Date,    
                WS.WeekDay_Name,  
                CT.Hour_Name  
            FROM Tbl_Teacher_Substituition TS    
            INNER JOIN Tbl_ClassTimings CT ON CT.Class_Timings_Id = TS.Class_Timings_Id  
            INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = TS.Week_Day_Id   
            INNER JOIN Tbl_Employee E ON E.Employee_Id = TS.Employee_In_Leave_Id  
            INNER JOIN Tbl_Employee EE ON EE.Employee_Id = TS.Employee_Substitute_Id  
            WHERE (TS.Leave_Date BETWEEN @From_Date AND @To_Date)             
        END
    ')
END
