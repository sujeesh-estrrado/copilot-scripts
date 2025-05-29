IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            
CREATE procedure [dbo].[SP_Get_Employee_All]               
(              
                  
@CurrentPage int = null,              
@PageSize int = null  ,          
@SearchTerm varchar(100)            
)              
                  
AS              
              
BEGIN              
    SET NOCOUNT ON              
              
    DECLARE @SqlString nvarchar(max)          
 Declare @SqlStringWithout nvarchar(max)              
    Declare @UpperBand int              
    Declare @LowerBand int                      
                  
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize              
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                  
              
    BEGIN              
               
        
        
IF @SearchTerm IS NOT NULL        
        
BEGIN        
        
 SET @SqlString=''WITH tempProfile AS              
        (SELECT e.Employee_Id as ID,    
d.Dept_Name as Department,    
e.Employee_FName+'''' ''''+e.Employee_LName+'''' '''' as [Employee Name] ,      
e.Identification_No,                        
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
e.Blood_Group as [Blood Group],              
e.Employee_Id_Card_No as [ID No],              
e.Employee_Nationality,          
e.Employee_State,            
e.Employee_Experience_If_Any,              
e.Employee_Father_Name,              
e.Employee_Nominee_Name,              
e.Employee_Nominee_Relation,              
e.Employee_Nominee_Phone,              
e.Employee_Nominee_Address,              
e.Employee_Status,              
e.Employee_Type,              
e.Employee_Img  ,           
e.Employee_Aadhar,                  
eo.Department_Id,    
e.Employee_DOB as DOB,    
e.Employee_Gender as Gender,                
e.Employee_Mobile as Mobile,    
eo.Employee_DOJ as DOJ              
              
,ROW_NUMBER() over (ORDER BY e.Employee_Id DESC) AS RowNumber    
              
  FROM [Tbl_Employee] e right join dbo.Tbl_Employee_Official eo on e.Employee_Id=eo.Employee_Id left join dbo.Tbl_Emp_Department d                    
on eo.Department_Id=d.Dept_Id where e.Employee_Status=0     
      
        
        
and  (e.Employee_FName like  ''''''+ @SearchTerm+''%''''       
      
or  e.Employee_Id_Card_No like  ''''''+ @SearchTerm+''%''''         
        
or  e.Blood_Group like  ''''''+ @SearchTerm+''%''''       
      
or  eo.Department_Id like  ''''''+ @SearchTerm+''%''''       
      
or  e.Employee_DOB like  ''''''+ @SearchTerm+''%''''       
      
or  e.Employee_Gender like  ''''''+ @SearchTerm+''%''''       
      
or  e.Employee_Mobile like  ''''''+ @SearchTerm+''%''''     
      
or  eo.Employee_DOJ like  ''''''+ @SearchTerm+''%''''     
        
)      
        
             
        )                   
              
        SELECT     
   ID,              
            Department,    
   [Employee Name],    
   [ID No],    
   Employee_FName,    
   Employee_LName,                   
   Employee_Permanent_Address,              
   Employee_Present_Address,              
   Employee_Phone,              
   Employee_Mail,                       
   Employee_Martial_Status,              
   [Blood Group],                        
   Employee_Nationality,          
   Employee_State,            
   Employee_Experience_If_Any,              
   Employee_Father_Name,              
   Employee_Nominee_Name,              
   Employee_Nominee_Relation,              
   Employee_Nominee_Phone,              
   Employee_Nominee_Address,              
   Employee_Status,              
   Employee_Type,              
   Employee_Img  ,           
   Employee_Aadhar,                  
   Department_Id,    
   DOB,    
   Gender,                
 Mobile,    
   DOJ,      
   RowNumber                                  
        FROM               
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)            
       
END        
    
--IF @SearchTerm is null          
        
 IF (@SearchTerm is null or @SearchTerm = '''')        
        
begin        
        
 SET @SqlString=''WITH tempProfile AS              
        (SELECT e.Employee_Id as ID,    
d.Dept_Name as Department,    
e.Employee_FName+'''' ''''+e.Employee_LName+'''' '''' as [Employee Name] ,      
e.Identification_No,                       
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
e.Blood_Group as [Blood Group],              
e.Employee_Id_Card_No as [ID No],              
e.Employee_Nationality,          
e.Employee_State,            
e.Employee_Experience_If_Any,              
e.Employee_Father_Name,              
e.Employee_Nominee_Name,              
e.Employee_Nominee_Relation,              
e.Employee_Nominee_Phone,              
e.Employee_Nominee_Address,              
e.Employee_Status,              
e.Employee_Type,              
e.Employee_Img  ,           
e.Employee_Aadhar,                  
eo.Department_Id,    
e.Employee_DOB as DOB,    
e.Employee_Gender as Gender,                
e.Employee_Mobile as Mobile,    
eo.Employee_DOJ as DOJ              
              
,ROW_NUMBER() over (ORDER BY e.Employee_Id DESC) AS RowNumber    
              
  FROM [Tbl_Employee] e right join dbo.Tbl_Employee_Official eo on e.Employee_Id=eo.Employee_Id left join dbo.Tbl_Emp_Department d                    
on eo.Department_Id=d.Dept_Id where e.Employee_Status=0        
        
        
)                   
              
        SELECT      
   ID,             
            Department,    
   [Employee Name],    
   [ID No],    
   Employee_FName,    
   Employee_LName,                   
   Employee_Permanent_Address,              
   Employee_Present_Address,              
   Employee_Phone,              
   Employee_Mail,                       
   Employee_Martial_Status,              
   [Blood Group],                        
   Employee_Nationality,          
   Employee_State,            
   Employee_Experience_If_Any,              
   Employee_Father_Name,              
   Employee_Nominee_Name,              
   Employee_Nominee_Relation,              
   Employee_Nominee_Phone,              
   Employee_Nominee_Address,              
   Employee_Status,              
   Employee_Type,              
   Employee_Img  ,           
   Employee_Aadhar,                  
   Department_Id,    
   DOB,    
   Gender,                
   Mobile,    
   DOJ,      
   RowNumber                                  
        FROM               
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)     
           
end        
        
   EXEC sp_executesql @SqlString              
          
             
    END              
END             
    ');
END;
