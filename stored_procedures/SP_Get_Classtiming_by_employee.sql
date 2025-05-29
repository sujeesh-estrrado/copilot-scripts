IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Classtiming_by_employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Classtiming_by_employee] --10          
(@Employeeid  bigint)              
as begin              
SELECT distinct Cti.Class_Timings_Id as ID, Cti.Hour_Name,          
LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.Start_Time, 100), 7)) AS Start_Time,                
LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.End_Time, 100), 7)) AS End_Time,      
  
        
LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.Start_Time, 100), 7))+''-''+                  
LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.End_Time, 100), 7)) AS time,                  
Cti.Is_BreakTime                   
FROM  Tbl_ClassTimings Cti  inner join  dbo.Tbl_Class_TimeTable CT              
on CT.Class_Timings_Id=Cti.Class_Timings_Id              
where CT.Employee_Id=@Employeeid              
        order by Start_Time       
              
              
              
end    
    ');
END;
