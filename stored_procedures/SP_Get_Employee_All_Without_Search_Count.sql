IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_All_Without_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Employee_All_Without_Search_Count]                                  
AS                                  
BEGIN     
                                 
SELECT ROW_NUMBER() over (ORDER BY e.Employee_Id DESC) AS RowNumber,

e.Employee_Id as ID,

e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee Name] ,
  
e.Employee_Id_Card_No as [ID No],
        
e.Blood_Group as [Blood Group],
 
d.Dept_Name as [Department],
 
e.Employee_DOB as [DOB],

e.Employee_Gender as [Gender],
            
e.Employee_Mobile as [Mobile],

eo.Employee_DOJ as [DOJ]        
       
  FROM [Tbl_Employee] e right join dbo.Tbl_Employee_Official eo on e.Employee_Id=eo.Employee_Id left join dbo.Tbl_Emp_Department d                
on eo.Department_Id=d.Dept_Id where e.Employee_Status=0         
        
        
    
        
end    ');
END;
