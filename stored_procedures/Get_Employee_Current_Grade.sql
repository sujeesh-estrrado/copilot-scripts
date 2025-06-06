-- Check if the procedure 'Get_Employee_Current_Grade' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_Current_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Get_Employee_Current_Grade](          
@Employee_Id bigint          
)          
as          
begin          
SELECT *                        
FROM                            
   (                 
        SELECT         
ROW_NUMBER() OVER                           
   (PARTITION BY  LS.Leave_Settings_Id ORDER BY  LS.Leave_Settings_Id) as num,  
 LS.*,G.Emp_Grade_Name , 
case when ELA.Emp_Leave_IsHalfDay=1 then ''Half Day'' else ''Full Day'' end as IsHalfDay   
FROM Tbl_Grade_Mapping GM        
inner join Tbl_Employee_Grade G on G.Emp_Grade_Id=GM.Emp_Grade_Id    
INNER JOIN Tbl_Leave_Settings LS ON GM.Emp_Grade_Id = LS.Grade_Id   
left JOIN Tbl_Emp_Leave_Apply ELA ON ELA.Employee_Id = GM.Employee_Id  
 where GM.Employee_Id=@Employee_Id and LS.Leave_Delete_Status=0 ) tbl                          
where tbl.num=1                        
         
          
end
    ')
END;
GO
