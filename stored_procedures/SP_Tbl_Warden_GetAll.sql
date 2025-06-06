IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Warden_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Warden_GetAll]                           
as                           
begin                 
SELECT     
--eo.*,ho.*,    
distinct    
Hostel_Name=substring((SELECT distinct ( '', '' + cast(hr.Hostel_Name as varchar(100)))      
FROM  Tbl_HostelRegistration hr  left join  Tbl_Hstl_EmployeeRegistration he on  hr.Hostel_Id = he.Hostel_Id   
where he.Employee_Id =e.Employee_Id     
FOR XML PATH( '''' )),3,1000),    
d.Dept_Name,    
e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee Name] ,           
e.Employee_Id,          
e.Employee_FName,          
e.Employee_LName,          
e.Employee_DOB,          
e.Employee_Gender,          
e.Employee_Permanent_Address,          
e.Employee_Present_Address,          
e.Employee_Phone,          
e.Employee_Mail,          
e.Employee_Mobile,          
e.Employee_Martial_Status,          
e.Blood_Group,          
e.Employee_Id_Card_No,          
e.Employee_Nationality,          
e.Employee_Experience_If_Any,          
e.Employee_Father_Name,          
e.Employee_Nominee_Name,          
e.Employee_Nominee_Relation,          
e.Employee_Nominee_Phone,          
e.Employee_Nominee_Address,          
e.Employee_Status,          
e.Employee_Type,          
e.Employee_Img  ,        
 eo.Department_Id ,e.Employee_DOB as DOB,e.Employee_Gender as Gender,            
                e.Employee_Mobile as Mobile1,eo.Employee_DOJ as DOJ     
  FROM [Tbl_Employee] e right join dbo.Tbl_Employee_Official eo on e.Employee_Id=eo.Employee_Id inner join Tbl_Hstl_EmployeeRegistration ho on e.Employee_Id = ho.Employee_Id      
 left join dbo.Tbl_Emp_Department d                
on eo.Department_Id=d.Dept_Id where e.Employee_Status=0              
order by   [Employee Name]            
end
    ')
END
